# =====================================================
# vectorize.py — Genera y almacena embeddings en pgvector
#
# Ejecutar UNA SOLA VEZ después de poblar la BD con 02_seed.sql:
#   python vectorize.py
#
# Qué hace:
#   1. Lee contenido_textual y resena de la BD
#   2. Aplica la estrategia de chunking correspondiente
#   3. Genera embeddings con sentence-transformers (local, sin costo)
#   4. Guarda los embeddings en embedding_contenido y embedding_resena
#   5. Crea los índices IVFFlat para búsqueda aproximada eficiente
# =====================================================

import sys
import psycopg2
from sentence_transformers import SentenceTransformer

from config import EMBEDDING_MODEL, EMBEDDING_DIM
from chunking import chunk_text
from conexion import get_connection, get_cursor


def load_model():
    print(f"[INFO] Cargando modelo de embeddings: {EMBEDDING_MODEL}")
    model = SentenceTransformer(EMBEDDING_MODEL)
    print(f"[INFO] Modelo cargado. Dimensión de salida: {EMBEDDING_DIM}")
    return model


def embed(model: SentenceTransformer, texts: list[str]) -> list[list[float]]:
    """Genera embeddings para una lista de textos."""
    vectors = model.encode(texts, show_progress_bar=False, normalize_embeddings=True)
    return [v.tolist() for v in vectors]


def vectorize_contenido(conn, model: SentenceTransformer):
    """
    Vectoriza contenido_textual (sinopsis y descripciones).
    Estrategia: Paragraph-Aware.
    Un registro en contenido_textual puede generar varios chunks;
    se almacena el embedding promedio del conjunto de chunks
    para mantener la relación 1:1 con embedding_contenido.
    """
    print("\n[INFO] Vectorizando contenido_textual...")
    with get_cursor(conn) as cur:
        cur.execute("""
            SELECT ct.id_contenido, ct.texto, p.titulo
            FROM contenido_textual ct
            JOIN pelicula p ON p.id_pelicula = ct.id_pelicula
            WHERE ct.texto IS NOT NULL
              AND ct.id_contenido NOT IN (
                  SELECT id_contenido FROM embedding_contenido
              )
        """)
        rows = cur.fetchall()

    if not rows:
        print("[INFO] No hay contenido nuevo para vectorizar.")
        return

    nuevos = 0
    with get_connection() as conn2:
        with get_cursor(conn2) as cur2:
            for row in rows:
                id_contenido = row["id_contenido"]
                texto        = row["texto"]
                titulo       = row["titulo"]

                # Chunking paragraph-aware
                chunks = chunk_text(texto, strategy="paragraph")
                if not chunks:
                    continue

                # Embedding promedio de los chunks
                vectors = embed(model, chunks)
                import numpy as np
                avg_vector = np.mean(vectors, axis=0).tolist()

                cur2.execute(
                    """
                    INSERT INTO embedding_contenido (id_contenido, embedding)
                    VALUES (%s, %s)
                    ON CONFLICT (id_contenido) DO UPDATE
                        SET embedding = EXCLUDED.embedding
                    """,
                    (id_contenido, avg_vector)
                )
                nuevos += 1
                print(f"  ✓ id_contenido={id_contenido} | {titulo} ({len(chunks)} chunks)")

        conn2.commit()

    print(f"[INFO] {nuevos} embeddings de contenido guardados.")


def vectorize_resenas(conn, model: SentenceTransformer):
    """
    Vectoriza reseñas de usuarios.
    Estrategia: Fixed-Size.
    """
    print("\n[INFO] Vectorizando reseñas...")
    with get_cursor(conn) as cur:
        cur.execute("""
            SELECT r.id_resena, r.texto, u.nombre AS usuario
            FROM resena r
            JOIN usuario u ON u.id_usuario = r.id_usuario
            WHERE r.texto IS NOT NULL
              AND r.id_resena NOT IN (
                  SELECT id_resena FROM embedding_resena
              )
        """)
        rows = cur.fetchall()

    if not rows:
        print("[INFO] No hay reseñas nuevas para vectorizar.")
        return

    nuevos = 0
    with get_connection() as conn2:
        with get_cursor(conn2) as cur2:
            for row in rows:
                id_resena = row["id_resena"]
                texto     = row["texto"]
                usuario   = row["usuario"]

                chunks = chunk_text(texto, strategy="fixed")
                if not chunks:
                    continue

                import numpy as np
                vectors    = embed(model, chunks)
                avg_vector = np.mean(vectors, axis=0).tolist()

                cur2.execute(
                    """
                    INSERT INTO embedding_resena (id_resena, embedding)
                    VALUES (%s, %s)
                    ON CONFLICT (id_resena) DO UPDATE
                        SET embedding = EXCLUDED.embedding
                    """,
                    (id_resena, avg_vector)
                )
                nuevos += 1
                print(f"  ✓ id_resena={id_resena} | usuario: {usuario}")

        conn2.commit()

    print(f"[INFO] {nuevos} embeddings de reseñas guardados.")


def create_ivfflat_indexes(conn):
    """
    Crea índices IVFFlat DESPUÉS de que hay datos.
    IVFFlat requiere datos previos para el training de los centroides.
    lists=10 es apropiado para datasets pequeños (< 1M filas).
    """
    print("\n[INFO] Creando índices IVFFlat...")
    indexes = [
        ("idx_emb_contenido", "embedding_contenido", "embedding"),
        ("idx_emb_resena",    "embedding_resena",    "embedding"),
        ("idx_emb_consulta",  "embedding_consulta",  "embedding"),
    ]
    with conn.cursor() as cur:
        for idx_name, table, col in indexes:
            cur.execute(f"""
                SELECT 1 FROM pg_indexes
                WHERE indexname = '{idx_name}'
            """)
            if cur.fetchone():
                print(f"  - Índice '{idx_name}' ya existe, omitiendo.")
                continue
            # Verificar que haya al menos 1 fila
            cur.execute(f"SELECT COUNT(*) FROM {table}")
            count = cur.fetchone()[0]
            if count == 0:
                print(f"  - Tabla '{table}' vacía, omitiendo índice.")
                continue
            print(f"  ✓ Creando {idx_name} sobre {table}...")
            cur.execute(f"""
                CREATE INDEX {idx_name} ON {table}
                USING ivfflat ({col} vector_cosine_ops)
                WITH (lists = 10)
            """)
    conn.commit()
    print("[INFO] Índices listos.")


def main():
    print("=" * 55)
    print("  VECTORIZACIÓN - PLATAFORMA STREAMING RAG")
    print("=" * 55)

    model = load_model()

    conn = get_connection()
    try:
        vectorize_contenido(conn, model)
        vectorize_resenas(conn, model)
        create_ivfflat_indexes(conn)
    finally:
        conn.close()

    print("\n[OK] Vectorización completa. Ya puedes ejecutar main.py")


if __name__ == "__main__":
    main()