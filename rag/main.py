import requests
from sentence_transformers import SentenceTransformer


from config import (
    EMBEDDING_MODEL,
    OLLAMA_MODEL,
    OLLAMA_URL,
    TOP_K,
    SYSTEM_PROMPT,
)
from conexion import get_connection, get_cursor

print("[INFO] Cargando modelo de embeddings...")
model = SentenceTransformer(EMBEDDING_MODEL)
print("[OK]  Modelo cargado\n")


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


def select_mode() -> int:
    print("\n┌─────────────────────────────────────────────┐")
    print("│         MODOS DE BÚSQUEDA DISPONIBLES       │")
    print("├─────────────────────────────────────────────┤")
    print("│  1. Semántica pura     (Top-K vectorial)    │")
    print("│  2. Híbrida por género (filtro SQL + vector)│")
    print("│  3. Híbrida por score  (umbral + metadata)  │")
    print("└─────────────────────────────────────────────┘")
    while True:
        try:
            mode = int(input("Selecciona el modo [1/2/3]: ").strip())
            if mode in (1, 2, 3):
                return mode
            print("  → Ingresa 1, 2 o 3.")
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
        user_id = 1  # Usuario de prueba (id_usuario=1 en el seed)

        # ── Selección de modo ─────────────────────────────────────────────
        mode = select_mode()

        genero_filtro = None
        if mode == 2:
            genero_filtro = input(
                "\nEscribe el género a filtrar\n"
                "(ej: Ciencia Ficción, Drama, Terror, Animación): "
            ).strip()

        # ── Consulta del usuario ──────────────────────────────────────────
        question = input("\nEscribe tu consulta: ").strip()
        if not question:
            print("[ERROR] La consulta no puede estar vacía.")
            return

        print("\n[INFO] Procesando...")

        # ── Paso 1: guardar consulta ──────────────────────────────────────
        id_consulta = save_query(conn, user_id, question)

        # ── Paso 2: embedding de la consulta ──────────────────────────────
        embedding = generate_embedding(question)

        # ── Paso 3: guardar embedding ─────────────────────────────────────
        save_query_embedding(conn, id_consulta, embedding)

        # ── Paso 4: retrieval según modo ──────────────────────────────────
        if mode == 1:
            print("[INFO] Modo: Búsqueda semántica pura")
            results = retrieve_semantic(conn, embedding)

        elif mode == 2:
            print(f"[INFO] Modo: Híbrida por género → '{genero_filtro}'")
            results = retrieve_hybrid_by_genre(conn, embedding, genero_filtro)
            if not results:
                print(
                    f"\n[AVISO] No se encontraron películas del género '{genero_filtro}'.\n"
                    "Verifica que el género existe en la base de datos.\n"
                    "Géneros disponibles: Ciencia Ficción, Drama, Acción, Terror, "
                    "Romance, Animación, Thriller, Aventura"
                )
                return

        else:  # mode == 3
            umbral = 0.30
            print(f"[INFO] Modo: Híbrida por score (umbral ≥ {umbral})")
            results = retrieve_hybrid_by_score(conn, embedding, umbral)

        if not results:
            print("\n[AVISO] No se encontraron resultados para esa consulta.")
            return

        # ── Paso 5: guardar resultados (trazabilidad) ─────────────────────
        save_results(conn, id_consulta, results)

        # ── Paso 6: mostrar tabla de resultados recuperados ───────────────
        print_results_table(results, mode)

        # ── Paso 7: construir contexto ────────────────────────────────────
        context = build_context(results)

        # ── Paso 8: generar respuesta con el LLM ──────────────────────────
        print("[INFO] Generando respuesta con el LLM...")
        answer = generate_answer(question, context)

        # ── Paso 9: guardar respuesta ─────────────────────────────────────
        save_answer(conn, id_consulta, answer, context)

        # ── Resultado final ───────────────────────────────────────────────
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