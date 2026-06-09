import io
import os
import requests
import numpy as np
from PIL import Image
from sentence_transformers import SentenceTransformer
from transformers import CLIPModel, CLIPProcessor
import torch

from config import (
    EMBEDDING_MODEL,
    OLLAMA_MODEL,
    OLLAMA_URL,
    TOP_K,
    SYSTEM_PROMPT,
)
from conexion import get_connection, get_cursor

print("[INFO] Cargando modelo de embeddings (MiniLM)...")
model = SentenceTransformer(EMBEDDING_MODEL)
print("[OK]  MiniLM cargado\n")

CLIP_MODEL_NAME = "openai/clip-vit-base-patch32"
print("[INFO] Cargando modelo CLIP para búsqueda multimodal...")
clip_model     = CLIPModel.from_pretrained(CLIP_MODEL_NAME)
clip_processor = CLIPProcessor.from_pretrained(CLIP_MODEL_NAME)
clip_model.eval()
print("[OK]  CLIP cargado (512 dims)\n")


def generate_embedding(text: str) -> list[float]:
    vector = model.encode(text, normalize_embeddings=True)
    return vector.tolist()

def save_query(conn, user_id: int, query_text: str) -> int:
    """
    Registra la consulta del usuario en la tabla `consulta`.
    Retorna el id_consulta generado (necesario para trazabilidad RAG).
    """
    with get_cursor(conn) as cur:
        cur.execute(
            """
            INSERT INTO consulta (id_usuario, texto)
            VALUES (%s, %s)
            RETURNING id_consulta
            """,
            (user_id, query_text),
        )
        result = cur.fetchone()
        conn.commit()
        return result["id_consulta"]


def save_query_embedding(conn, id_consulta: int, embedding: list[float]):
    with get_cursor(conn) as cur:
        cur.execute(
            """
            INSERT INTO embedding_consulta (id_consulta, embedding)
            VALUES (%s, %s)
            ON CONFLICT (id_consulta)
            DO UPDATE SET embedding = EXCLUDED.embedding
            """,
            (id_consulta, embedding),
        )
    conn.commit()


def retrieve_semantic(conn, embedding: list[float]) -> list[dict]:
    """
    MODO 1 — Búsqueda semántica pura (Top-K Similarity Search).

    Recupera los TOP_K contenidos más similares semánticamente
    sin ningún filtro relacional adicional.
    Un solo chunk por película (ROW_NUMBER deduplicación).

    Basado en: sección 5.1 del PDF — Top-K Similarity Search.
    Patrón CTE del PDF: el score se calcula UNA sola vez por fila,
    no dos veces (evita doble cómputo vectorial).
    """
    sql = """
        WITH candidatos AS (
            SELECT
                ec.id_contenido,
                ct.texto,
                ct.tipo,
                p.id_pelicula,
                p.titulo,
                p.fecha_lanzamiento,
                1 - (ec.embedding <=> %s::vector) AS similitud,
                ROW_NUMBER() OVER (
                    PARTITION BY p.id_pelicula
                    ORDER BY ec.embedding <=> %s::vector ASC
                ) AS rank_en_pelicula
            FROM embedding_contenido ec
            JOIN contenido_textual ct
                ON ct.id_contenido = ec.id_contenido
            JOIN pelicula p
                ON p.id_pelicula = ct.id_pelicula
        )
        SELECT
            id_contenido,
            texto,
            tipo,
            id_pelicula,
            titulo,
            fecha_lanzamiento,
            ROUND(similitud::numeric, 4) AS similitud
        FROM candidatos
        WHERE rank_en_pelicula = 1
        ORDER BY similitud DESC
        LIMIT %s
    """
    with get_cursor(conn) as cur:
        cur.execute(sql, (embedding, embedding, TOP_K))
        return cur.fetchall()

def retrieve_hybrid_by_genre(
    conn, embedding: list[float], genero: str
) -> list[dict]:
    """
    MODO 2 — Consulta híbrida: filtro relacional por género + similitud vectorial.

    El filtro WHERE sobre `genero.nombre` reduce el espacio de búsqueda
    vectorial a solo las películas del género solicitado; el ORDER BY
    vectorial ordena semánticamente dentro de ese subconjunto.

    Basado en: sección 6, Caso 1 del PDF —
    "Filtro Relacional + Similitud Semántica".
    Impacto: si hay 200 películas y 40 son del género pedido,
    el vector scan trabaja sobre el 20% del espacio.
    """
    sql = """
        WITH candidatos AS (
            SELECT
                ec.id_contenido,
                ct.texto,
                ct.tipo,
                p.id_pelicula,
                p.titulo,
                p.fecha_lanzamiento,
                g.nombre AS genero,
                1 - (ec.embedding <=> %s::vector) AS similitud,
                ROW_NUMBER() OVER (
                    PARTITION BY p.id_pelicula
                    ORDER BY ec.embedding <=> %s::vector ASC
                ) AS rank_en_pelicula
            FROM embedding_contenido ec
            JOIN contenido_textual ct
                ON ct.id_contenido = ec.id_contenido
            JOIN pelicula p
                ON p.id_pelicula = ct.id_pelicula
            JOIN pelicula_genero pg
                ON pg.id_pelicula = p.id_pelicula
            JOIN genero g
                ON g.id_genero = pg.id_genero
            WHERE
                LOWER(g.nombre) = LOWER(%s)
        )
        SELECT
            id_contenido,
            texto,
            tipo,
            id_pelicula,
            titulo,
            fecha_lanzamiento,
            genero,
            ROUND(similitud::numeric, 4) AS similitud
        FROM candidatos
        WHERE rank_en_pelicula = 1
        ORDER BY similitud DESC
        LIMIT %s
    """
    with get_cursor(conn) as cur:
        print(f"Genero recibido: >{genero}<")
        print(f"Longitud: {len(genero)}")
        cur.execute(sql, (embedding, embedding, genero, TOP_K))
        return cur.fetchall()


def retrieve_hybrid_by_score(
    conn, embedding: list[float], umbral: float = 0.30
) -> list[dict]:
    """
    MODO 3 — Consulta híbrida con umbral de score semántico + etiqueta de relevancia.

    Filtra resultados cuya similitud coseno supere el umbral mínimo
    y categoriza cada resultado según su nivel de relevancia.
    Incluye información enriquecida: géneros y calificación promedio
    desde las tablas relacionales.

    Basado en: sección 6, Caso 3 del PDF —
    "Filtro por Idioma + Umbral de Score Semántico".
    """
    sql = """
        WITH candidatos AS (
            SELECT
                ec.id_contenido,
                ct.texto,
                ct.tipo,
                p.id_pelicula,
                p.titulo,
                p.fecha_lanzamiento,
                1 - (ec.embedding <=> %s::vector) AS similitud,
                ROW_NUMBER() OVER (
                    PARTITION BY p.id_pelicula
                    ORDER BY ec.embedding <=> %s::vector ASC
                ) AS rank_en_pelicula
            FROM embedding_contenido ec
            JOIN contenido_textual ct
                ON ct.id_contenido = ec.id_contenido
            JOIN pelicula p
                ON p.id_pelicula = ct.id_pelicula
        ),
        filtrados AS (
            SELECT *
            FROM candidatos
            WHERE rank_en_pelicula = 1
              AND similitud >= %s
        ),
        generos_agrupados AS (
            SELECT
                pg.id_pelicula,
                STRING_AGG(g.nombre, ', ' ORDER BY g.nombre) AS generos
            FROM pelicula_genero pg
            JOIN genero g ON g.id_genero = pg.id_genero
            GROUP BY pg.id_pelicula
        ),
        calificaciones AS (
            SELECT
                id_pelicula,
                ROUND(AVG(calificacion)::numeric, 1) AS calificacion_promedio,
                COUNT(*) AS total_resenas
            FROM resena
            GROUP BY id_pelicula
        )
        SELECT
            f.id_contenido,
            f.texto,
            f.tipo,
            f.id_pelicula,
            f.titulo,
            f.fecha_lanzamiento,
            COALESCE(ga.generos, 'Sin clasificar') AS generos,
            COALESCE(c.calificacion_promedio, 0)   AS calificacion_promedio,
            COALESCE(c.total_resenas, 0)            AS total_resenas,
            ROUND(f.similitud::numeric, 4)          AS similitud,
            CASE
                WHEN f.similitud >= 0.70 THEN '★★★ Excelente'
                WHEN f.similitud >= 0.50 THEN '★★  Alta'
                WHEN f.similitud >= 0.30 THEN '★   Media'
                ELSE                          '    Baja'
            END AS nivel_relevancia
        FROM filtrados f
        LEFT JOIN generos_agrupados ga ON ga.id_pelicula = f.id_pelicula
        LEFT JOIN calificaciones c      ON c.id_pelicula  = f.id_pelicula
        ORDER BY f.similitud DESC
        LIMIT %s
    """
    with get_cursor(conn) as cur:
        cur.execute(sql, (embedding, embedding, umbral, TOP_K))
        return cur.fetchall()

def save_results(conn, id_consulta: int, results: list[dict]):
    """
    Registra en `resultado_busqueda` cada película recuperada,
    vinculada a la consulta que la originó (FK id_consulta).
    Esto garantiza la trazabilidad del pipeline RAG.
    """
    with get_cursor(conn) as cur:
        for row in results:
            score = float(row["similitud"]) if row["similitud"] else 0.0
            # NUMERIC(5,4) admite valores entre -9.9999 y 9.9999
            score = max(-9.9999, min(9.9999, score))
            cur.execute(
                """
                INSERT INTO resultado_busqueda
                    (id_consulta, id_pelicula, score_similitud)
                VALUES (%s, %s, %s)
                """,
                (id_consulta, row["id_pelicula"], score),
            )
    conn.commit()


# PASO 5 — CONSTRUCCIÓN DEL CONTEXTO PARA EL LLM


def build_context(results: list[dict]) -> str:
    """
    Concatena los chunks recuperados en un bloque de texto estructurado
    que se pasa como contexto al LLM.
    Cada bloque incluye metadata relacional (título, año, géneros, calificación)
    más el texto semántico del chunk.
    """
    blocks = []
    for i, row in enumerate(results, 1):
        lines = [
            f"[Resultado {i}]",
            f"Película    : {row['titulo']}",
        ]

        # Campos opcionales que solo existen en algunos modos
        if row.get("fecha_lanzamiento"):
            lines.append(f"Año         : {row['fecha_lanzamiento'].year}")
        if row.get("generos"):
            lines.append(f"Géneros     : {row['generos']}")
        if row.get("calificacion_promedio") is not None and row.get("total_resenas", 0) > 0:
            lines.append(
                f"Calificación: {row['calificacion_promedio']}/5 "
                f"({row['total_resenas']} reseñas)"
            )
        if row.get("nivel_relevancia"):
            lines.append(f"Relevancia  : {row['nivel_relevancia']}")

        lines.append(f"Score       : {row['similitud']:.4f}")
        lines.append(f"Tipo        : {row.get('tipo', 'N/A')}")
        lines.append("")
        lines.append(row["texto"])

        blocks.append("\n".join(lines))

    return "\n\n" + ("─" * 50 + "\n\n").join(blocks)


def generate_answer(question: str, context: str) -> str:
    """
    Envía la consulta + contexto recuperado al LLM local (Ollama).
    Si Ollama no está disponible, informa al usuario claramente.
    """
    if not context.strip():
        return "No encontré información suficiente en la base de datos para responder esa consulta."

    prompt = f"""{SYSTEM_PROMPT}

CONTEXTO RECUPERADO DE LA BASE DE DATOS:
{context}

PREGUNTA DEL USUARIO:
{question}

RESPUESTA:"""

    payload = {
        "model":  OLLAMA_MODEL,
        "prompt": prompt,
        "stream": False,
    }

    try:
        response = requests.post(OLLAMA_URL, json=payload, timeout=120)
        response.raise_for_status()
        return response.json()["response"]
    except requests.exceptions.ConnectionError:
        return (
            "[ERROR] No se pudo conectar con Ollama.\n"
            "Asegúrate de que Ollama está corriendo: ollama serve\n"
            "Y de que el modelo está descargado: ollama pull llama3.2\n\n"
            "─── Contexto recuperado (sin respuesta del LLM) ───\n"
            + context
        )
    except Exception as e:
        return f"[ERROR] Fallo al generar respuesta: {e}"


# PERSISTENCIA DE RESPUESTA


def save_answer(conn, id_consulta: int, answer: str, context: str):
    """Guarda la respuesta generada y el contexto usado en `respuesta`."""
    with get_cursor(conn) as cur:
        cur.execute(
            """
            INSERT INTO respuesta (id_consulta, texto, contexto)
            VALUES (%s, %s, %s)
            """,
            (id_consulta, answer, context),
        )
    conn.commit()


# ─────────────────────────────────────────────────────────────────────────────
# MENÚ INTERACTIVO
# ─────────────────────────────────────────────────────────────────────────────

def print_results_table(results: list[dict], mode: int):
    """Muestra una tabla resumen de los chunks recuperados."""
    print(f"\n{'─'*60}")
    print(f"  {len(results)} resultado(s) recuperado(s)")
    print(f"{'─'*60}")
    for i, r in enumerate(results, 1):
        genero_str = f" | {r['generos']}" if r.get("generos") else ""
        nivel_str  = f" | {r['nivel_relevancia']}" if r.get("nivel_relevancia") else ""
        print(f"  {i}. [{r['similitud']:.4f}] {r['titulo']}{genero_str}{nivel_str}")
    print(f"{'─'*60}\n")




# ─────────────────────────────────────────────────────────────────────────────
# FUNCIONES MULTIMODALES — CLIP (texto ↔ imagen)
#
# CLIP proyecta texto e imágenes en el MISMO espacio vectorial de 512 dims.
# Esto permite:
#   - Modo 4: texto → imagen  (embed el texto con CLIP, buscar en embedding_imagen)
#   - Modo 5: imagen → texto  (embed la imagen con CLIP, buscar en embedding_imagen
#                              y luego recuperar el contenido textual de esa película)
#
# Basado en: sección "Consultas Multimodales" del PDF —
# "CLIP mapea tanto texto como imágenes al mismo espacio vectorial de 512 dims"
# ─────────────────────────────────────────────────────────────────────────────

def embed_text_clip(text: str) -> list[float]:

    inputs = clip_processor(
        text=[text],
        return_tensors="pt",
        padding=True,
        truncation=True,
        max_length=77
    )

    with torch.no_grad():

        features = clip_model.get_text_features(**inputs)

        print("\nDEBUG TEXT")
        print(type(features))

        if hasattr(features, "pooler_output"):
            print("pooler_output:", features.pooler_output.shape)
            features = features.pooler_output

        elif isinstance(features, tuple):
            print("tuple:", len(features))
            features = features[0]

        features = features / features.norm(
            p=2,
            dim=-1,
            keepdim=True
        )

    return features.squeeze().tolist()


def embed_text_clip(text: str) -> list[float]:

    inputs = clip_processor(
        text=[text],
        return_tensors="pt",
        padding=True,
        truncation=True,
        max_length=77
    )

    with torch.no_grad():

        features = clip_model.get_text_features(**inputs)

        print("\nDEBUG TEXT")
        print(type(features))

        if hasattr(features, "pooler_output"):
            print("pooler_output:", features.pooler_output.shape)
            features = features.pooler_output

        elif isinstance(features, tuple):
            print("tuple:", len(features))
            features = features[0]

        features = features / features.norm(
            p=2,
            dim=-1,
            keepdim=True
        )

    return features.squeeze().tolist()

def embed_image_clip(image_path: str) -> list[float] | None:
    """
    Genera embedding CLIP desde:
      - archivo local
      - URL remota
    """

    try:

        # URL remota
        if image_path.startswith("http://") or image_path.startswith("https://"):

            response = requests.get(
                image_path,
                timeout=15,
                headers={"User-Agent": "Mozilla/5.0"}
            )

            response.raise_for_status()

            image = Image.open(
                io.BytesIO(response.content)
            ).convert("RGB")

        # Archivo local
        else:

            if not os.path.exists(image_path):
                print(f"[ERROR] Archivo no encontrado: {image_path}")
                return None

            image = Image.open(
                image_path
            ).convert("RGB")

        inputs = clip_processor(
            images=image,
            return_tensors="pt"
        )

        with torch.no_grad():

            features = clip_model.get_image_features(**inputs)

            # Compatibilidad transformers 5.x
            if hasattr(features, "pooler_output"):
                features = features.pooler_output

            elif not isinstance(features, torch.Tensor):
                features = features[0]

            features = features / features.norm(
                p=2,
                dim=-1,
                keepdim=True
            )

        return features.squeeze().tolist()

    except Exception as e:
        print(f"[ERROR] No se pudo procesar la imagen: {e}")
        return None


def retrieve_text_to_image(conn, clip_text_embedding: list[float]) -> list[dict]:
    """
    MODO 4 — Texto → Imagen (búsqueda multimodal).

    Usa el embedding CLIP del texto de la consulta para buscar
    en `embedding_imagen` (vectores de pósters).
    Retorna las películas cuyos pósters son semánticamente más
    similares a la descripción textual.

    Basado en: sección "Consultas Multimodales" del PDF —
    JOIN entre tabla vectorial de imagen y tablas relacionales.
    """
    sql = """
        WITH candidatos AS (
            SELECT
                ei.id_imagen,
                i.url,
                i.tipo,
                p.id_pelicula,
                p.titulo,
                p.fecha_lanzamiento,
                1 - (ei.embedding <=> %s::vector) AS similitud,
                ROW_NUMBER() OVER (
                    PARTITION BY p.id_pelicula
                    ORDER BY ei.embedding <=> %s::vector ASC
                ) AS rank_en_pelicula
            FROM embedding_imagen ei
            JOIN imagen i     ON i.id_imagen     = ei.id_imagen
            JOIN pelicula p   ON p.id_pelicula   = i.id_pelicula
        ),
        generos_agrupados AS (
            SELECT
                pg.id_pelicula,
                STRING_AGG(g.nombre, ', ' ORDER BY g.nombre) AS generos
            FROM pelicula_genero pg
            JOIN genero g ON g.id_genero = pg.id_genero
            GROUP BY pg.id_pelicula
        )
        SELECT
            c.id_imagen,
            c.url             AS url_poster,
            c.id_pelicula,
            c.titulo,
            c.fecha_lanzamiento,
            COALESCE(ga.generos, 'Sin clasificar') AS generos,
            ROUND(c.similitud::numeric, 4)          AS similitud
        FROM candidatos c
        LEFT JOIN generos_agrupados ga ON ga.id_pelicula = c.id_pelicula
        WHERE c.rank_en_pelicula = 1
        ORDER BY c.similitud DESC
        LIMIT %s
    """
    with get_cursor(conn) as cur:
        cur.execute(sql, (clip_text_embedding, clip_text_embedding, TOP_K))
        return cur.fetchall()


def retrieve_image_to_text(conn, clip_image_embedding: list[float]) -> list[dict]:
    """
    MODO 5 — Imagen → Texto (búsqueda multimodal inversa).

    Usa el embedding CLIP de una imagen local para buscar
    en `embedding_imagen` el póster más similar, luego recupera
    el contenido textual (sinopsis/descripción) de esa película.
    Permite preguntar "¿qué película tiene un poster similar a esta imagen?"

    Basado en: sección "Consultas Multimodales" del PDF —
    "CLIP hace posible comparar directamente descripciones textuales con imágenes".
    """
    sql = """
        WITH imagenes_similares AS (
            SELECT
                ei.id_imagen,
                i.id_pelicula,
                1 - (ei.embedding <=> %s::vector) AS similitud_imagen,
                ROW_NUMBER() OVER (
                    PARTITION BY i.id_pelicula
                    ORDER BY ei.embedding <=> %s::vector ASC
                ) AS rank_en_pelicula
            FROM embedding_imagen ei
            JOIN imagen i ON i.id_imagen = ei.id_imagen
        ),
        peliculas_top AS (
            SELECT id_pelicula, similitud_imagen
            FROM imagenes_similares
            WHERE rank_en_pelicula = 1
            ORDER BY similitud_imagen DESC
            LIMIT %s
        ),
        generos_agrupados AS (
            SELECT
                pg.id_pelicula,
                STRING_AGG(g.nombre, ', ' ORDER BY g.nombre) AS generos
            FROM pelicula_genero pg
            JOIN genero g ON g.id_genero = pg.id_genero
            GROUP BY pg.id_pelicula
        )
        SELECT
            pt.id_pelicula,
            p.titulo,
            p.fecha_lanzamiento,
            COALESCE(ga.generos, 'Sin clasificar') AS generos,
            ct.texto,
            ct.tipo,
            ROUND(pt.similitud_imagen::numeric, 4) AS similitud
        FROM peliculas_top pt
        JOIN pelicula p           ON p.id_pelicula  = pt.id_pelicula
        LEFT JOIN contenido_textual ct ON ct.id_pelicula = pt.id_pelicula
                                      AND ct.tipo = 'sinopsis'
        LEFT JOIN generos_agrupados ga ON ga.id_pelicula = pt.id_pelicula
        ORDER BY pt.similitud_imagen DESC
    """
    with get_cursor(conn) as cur:
        cur.execute(sql, (clip_image_embedding, clip_image_embedding, TOP_K))
        return cur.fetchall()


def build_context_multimodal(results: list[dict], mode: int) -> str:
    """
    Construye el contexto para el LLM en modos multimodales.
    Modo 4: incluye URL del póster y géneros.
    Modo 5: incluye sinopsis recuperada por similitud visual.
    """
    blocks = []
    for i, row in enumerate(results, 1):
        lines = [f"[Resultado {i}]", f"Película  : {row['titulo']}"]
        if row.get("fecha_lanzamiento"):
            lines.append(f"Año       : {row['fecha_lanzamiento'].year}")
        if row.get("generos"):
            lines.append(f"Géneros   : {row['generos']}")
        lines.append(f"Score     : {row['similitud']:.4f}")
        if mode == 4 and row.get("url_poster"):
            lines.append(f"Póster    : {row['url_poster']}")
        if mode == 5 and row.get("texto"):
            lines.append(f"\nSinopsis:\n{row['texto']}")
        blocks.append("\n".join(lines))
    return "\n\n" + ("─" * 50 + "\n\n").join(blocks)


def print_multimodal_results(results: list[dict], mode: int):
    """Muestra tabla resumen para modos multimodales."""
    label = "texto→imagen" if mode == 4 else "imagen→texto"
    print(f"\n{'─'*60}")
    print(f"  {len(results)} resultado(s) [{label}]")
    print(f"{'─'*60}")
    for i, r in enumerate(results, 1):
        genero_str = f" | {r['generos']}" if r.get("generos") else ""
        print(f"  {i}. [{r['similitud']:.4f}] {r['titulo']}{genero_str}")
        if mode == 4 and r.get("url_poster"):
            print(f"       Póster: {r['url_poster']}")
    print(f"{'─'*60}\n")


def select_mode() -> int:
    print("\n┌──────────────────────────────────────────────────┐")
    print("│           MODOS DE BÚSQUEDA DISPONIBLES          │")
    print("├──────────────────────────────────────────────────┤")
    print("│  1. Semántica pura      (Top-K vectorial)        │")
    print("│  2. Híbrida por género  (filtro SQL + vector)    │")
    print("│  3. Híbrida por score   (umbral + metadata)      │")
    print("│  4. Texto → Imagen      (CLIP multimodal)        │")
    print("│  5. Imagen → Texto      (CLIP multimodal)        │")
    print("└──────────────────────────────────────────────────┘")
    while True:
        try:
            mode = int(input("Selecciona el modo [1/2/3/4/5]: ").strip())
            if mode in (1, 2, 3, 4, 5):
                return mode
            print("  → Ingresa 1, 2, 3, 4 o 5.")
        except ValueError:
            print("  → Ingresa un número.")


# ─────────────────────────────────────────────────────────────────────────────
# MAIN — Orquesta el pipeline completo
# ─────────────────────────────────────────────────────────────────────────────

def main():
    print("=" * 60)
    print("         PLATAFORMA STREAMING — SISTEMA RAG")
    print("=" * 60)

    conn = get_connection()

    try:
        user_id = 1

        mode = select_mode()

        # ── Modos multimodales (4 y 5) ────────────────────────────────────
        if mode == 4:
            question = input(
                "\n[MODO 4 — Texto → Imagen]\n"
                "Describe visualmente lo que buscas\n"
                "(ej: 'poster oscuro con un hombre con máscara'): "
            ).strip()
            if not question:
                print("[ERROR] La descripción no puede estar vacía.")
                return

            print("\n[INFO] Generando embedding CLIP del texto...")
            clip_emb = embed_text_clip(question)

            print("[INFO] Buscando pósters similares...")
            results = retrieve_text_to_image(conn, clip_emb)

            if not results:
                print("\n[AVISO] No se encontraron imágenes. Ejecuta vectorize_multimodal.py primero.")
                return

            print_multimodal_results(results, mode)
            context = build_context_multimodal(results, mode)

            id_consulta = save_query(conn, user_id, question)
            save_query_embedding(conn, id_consulta, generate_embedding(question))
            save_results(conn, id_consulta, results)

            print("[INFO] Generando respuesta con el LLM...")
            answer = generate_answer(question, context)
            save_answer(conn, id_consulta, answer, context)

            print("\n" + "=" * 60)
            print("  RESPUESTA")
            print("=" * 60)
            print(answer)
            print("=" * 60)
            return

        if mode == 5:
            image_path = input(
                "\n[MODO 5 — Imagen → Texto]\n"
                "Ruta local a la imagen que quieres consultar\n"
                "(ej: C:\\Users\\juan\\Downloads\\poster.jpg): "
            ).strip().strip('"')

            print("\n[INFO] Generando embedding CLIP de la imagen...")
            clip_emb = embed_image_clip(image_path)
            if clip_emb is None:
                return

            print("[INFO] Buscando películas con póster similar...")
            results = retrieve_image_to_text(conn, clip_emb)

            if not results:
                print("\n[AVISO] No se encontraron resultados. Ejecuta vectorize_multimodal.py primero.")
                return

            print_multimodal_results(results, mode)
            context = build_context_multimodal(results, mode)

            question = f"Imagen consultada: {os.path.basename(image_path)}"
            id_consulta = save_query(conn, user_id, question)
            save_query_embedding(conn, id_consulta, generate_embedding(question))
            save_results(conn, id_consulta, results)

            print("[INFO] Generando respuesta con el LLM...")
            answer = generate_answer(question, context)
            save_answer(conn, id_consulta, answer, context)

            print("\n" + "=" * 60)
            print("  RESPUESTA")
            print("=" * 60)
            print(answer)
            print("=" * 60)
            return

        # ── Modos 1-3 (texto → texto) ─────────────────────────────────────
        genero_filtro = None
        if mode == 2:
            genero_filtro = input(
                "\nEscribe el género a filtrar\n"
                "(ej: Ciencia Ficción, Drama, Terror, Animación): "
            ).strip()

        question = input("\nEscribe tu consulta: ").strip()
        if not question:
            print("[ERROR] La consulta no puede estar vacía.")
            return

        print("\n[INFO] Procesando...")

        id_consulta = save_query(conn, user_id, question)
        embedding   = generate_embedding(question)
        save_query_embedding(conn, id_consulta, embedding)

        if mode == 1:
            print("[INFO] Modo: Búsqueda semántica pura")
            results = retrieve_semantic(conn, embedding)

        elif mode == 2:
            print(f"[INFO] Modo: Híbrida por género → '{genero_filtro}'")
            results = retrieve_hybrid_by_genre(conn, embedding, genero_filtro)
            if not results:
                print(
                    f"\n[AVISO] No se encontraron películas del género '{genero_filtro}'.\n"
                    "Géneros disponibles: Ciencia Ficción, Drama, Acción, Terror, "
                    "Romance, Animación, Thriller, Aventura"
                )
                return

        else:
            umbral = 0.30
            print(f"[INFO] Modo: Híbrida por score (umbral ≥ {umbral})")
            results = retrieve_hybrid_by_score(conn, embedding, umbral)

        if not results:
            print("\n[AVISO] No se encontraron resultados para esa consulta.")
            return

        save_results(conn, id_consulta, results)
        print_results_table(results, mode)
        context = build_context(results)

        print("[INFO] Generando respuesta con el LLM...")
        answer = generate_answer(question, context)
        save_answer(conn, id_consulta, answer, context)

        print("\n" + "=" * 60)
        print("  RESPUESTA")
        print("=" * 60)
        print(answer)
        print("=" * 60)
        print(f"[INFO] Consulta #{id_consulta} guardada con {len(results)} resultado(s).")

    finally:
        conn.close()


if __name__ == "__main__":
    main()