# =====================================================
# vectorize_multimodal.py — Vectoriza imágenes con CLIP
#
# Ejecutar UNA VEZ después de 04_seed_imagenes.sql:
#   python vectorize_multimodal.py
#
# Qué hace:
#   1. Lee las URLs de la tabla `imagen`
#   2. Descarga cada póster desde TMDB
#   3. Genera embeddings con CLIP ViT-B/32 (512 dims)
#   4. Guarda los embeddings en `embedding_imagen`
#   5. Crea el índice IVFFlat para búsqueda aproximada
#
# Modelo: openai/clip-vit-base-patch32 (local, gratuito, ~600MB)
# =====================================================

import io
import time
import requests
import numpy as np
from PIL import Image
from transformers import CLIPProcessor, CLIPModel
import torch

from conexion import get_connection, get_cursor

CLIP_MODEL_NAME = "openai/clip-vit-base-patch32"
DOWNLOAD_TIMEOUT = 15   # segundos por imagen
RETRY_DELAY      = 2    # segundos entre reintentos


# ─────────────────────────────────────────────────────────────────────────────
# CARGA DEL MODELO CLIP
# ─────────────────────────────────────────────────────────────────────────────

def load_clip():
    print(f"[INFO] Cargando modelo CLIP: {CLIP_MODEL_NAME}")
    print("       (primera vez: ~600MB de descarga, espera un momento...)")
    model     = CLIPModel.from_pretrained(CLIP_MODEL_NAME)
    processor = CLIPProcessor.from_pretrained(CLIP_MODEL_NAME)
    model.eval()
    print("[OK]  CLIP cargado. Dimensión de embedding de imagen: 512")
    return model, processor


# ─────────────────────────────────────────────────────────────────────────────
# EMBEDDING DE IMAGEN (URL → vector 512D)
# ─────────────────────────────────────────────────────────────────────────────

def embed_image_from_url(url: str, model, processor) -> list[float] | None:
    try:
        headers = {"User-Agent": "Mozilla/5.0"}

        resp = requests.get(
            url,
            timeout=DOWNLOAD_TIMEOUT,
            headers=headers
        )
        resp.raise_for_status()

        image = Image.open(
            io.BytesIO(resp.content)
        ).convert("RGB")

        inputs = processor(
            images=image,
            return_tensors="pt"
        )

        with torch.no_grad():

            features = model.get_image_features(**inputs)

            # Compatibilidad con Transformers 5.x
            if hasattr(features, "pooler_output"):
                features = features.pooler_output

            features = features / features.norm(
                p=2,
                dim=-1,
                keepdim=True
            )

        return features.squeeze().tolist()

    except requests.exceptions.HTTPError as e:
        print(
            f"    [WARN] HTTP {e.response.status_code} "
            f"al descargar {url}"
        )
        return None

    except Exception as e:
        print(
            f"    [WARN] Error procesando imagen "
            f"{url}: {e}"
        )
        return None


# ─────────────────────────────────────────────────────────────────────────────
# EMBEDDING DE TEXTO CON CLIP (texto → vector 512D en espacio compartido)
# ─────────────────────────────────────────────────────────────────────────────

def embed_text_clip(text: str) -> list[float]:
    """
    Proyecta texto al espacio vectorial CLIP de 512 dims.
    Compatible con transformers 5.x.
    """

    inputs = clip_processor(
        text=[text],
        return_tensors="pt",
        padding=True,
        truncation=True,
        max_length=77
    )

    with torch.no_grad():

        with torch.no_grad():

            features = clip_model.get_image_features(**inputs)

            if hasattr(features, "pooler_output"):
                features = features.pooler_output

            elif not isinstance(features, torch.Tensor):
                features = features[0]

            features = features / features.norm(
                p=2,
                dim=-1,
                keepdim=True
            )

        # transformers 5.x
        if hasattr(features, "pooler_output"):
            features = features.pooler_output

        # transformers 4.x
        elif not isinstance(features, torch.Tensor):
            features = features[0]

        with torch.no_grad():

            features = clip_model.get_image_features(**inputs)

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

# ─────────────────────────────────────────────────────────────────────────────
# VECTORIZACIÓN DE TODAS LAS IMÁGENES
# ─────────────────────────────────────────────────────────────────────────────

def vectorize_imagenes(conn, model, processor):
    """
    Lee todas las URLs de `imagen`, genera embeddings CLIP
    y los guarda en `embedding_imagen`.
    Omite imágenes ya vectorizadas (ON CONFLICT).
    """
    print("\n[INFO] Leyendo URLs de imágenes pendientes...")
    with get_cursor(conn) as cur:
        cur.execute("""
            SELECT i.id_imagen, i.url, i.tipo, p.titulo
            FROM imagen i
            JOIN pelicula p ON p.id_pelicula = i.id_pelicula
            WHERE i.url IS NOT NULL
              AND i.id_imagen NOT IN (
                  SELECT id_imagen FROM embedding_imagen
              )
            ORDER BY i.id_imagen
        """)
        rows = cur.fetchall()

    if not rows:
        print("[INFO] No hay imágenes nuevas para vectorizar.")
        return

    print(f"[INFO] {len(rows)} imagen(es) pendiente(s).\n")

    ok = 0
    fail = 0

    with get_connection() as conn2:
        with get_cursor(conn2) as cur2:
            for row in rows:
                id_imagen = row["id_imagen"]
                url       = row["url"]
                titulo    = row["titulo"]

                print(f"  → [{id_imagen:>3}] {titulo[:40]:<40} {url[-40:]}")

                vector = embed_image_from_url(url, model, processor)

                if vector is None:
                    print(f"         [SKIP] No se pudo vectorizar.")
                    fail += 1
                    time.sleep(RETRY_DELAY)
                    continue

                cur2.execute(
                    """
                    INSERT INTO embedding_imagen (id_imagen, embedding, modelo)
                    VALUES (%s, %s, %s)
                    ON CONFLICT (id_imagen) DO UPDATE
                        SET embedding = EXCLUDED.embedding,
                            modelo    = EXCLUDED.modelo
                    """,
                    (id_imagen, vector, CLIP_MODEL_NAME)
                )
                ok += 1
                print(f"         [OK]   Embedding guardado (512 dims).")

                # Pausa pequeña para no saturar TMDB
                time.sleep(0.3)

        conn2.commit()

    print(f"\n[INFO] Resultado: {ok} vectorizadas, {fail} fallidas.")


# ─────────────────────────────────────────────────────────────────────────────
# ÍNDICE IVFFLAT PARA IMÁGENES
# ─────────────────────────────────────────────────────────────────────────────

def create_image_index(conn):
    print("\n[INFO] Creando índice IVFFlat para embedding_imagen...")
    with conn.cursor() as cur:
        cur.execute("""
            SELECT 1 FROM pg_indexes WHERE indexname = 'idx_ivfflat_emb_imagen'
        """)
        if cur.fetchone():
            print("  - Índice ya existe, omitiendo.")
            conn.commit()
            return

        cur.execute("SELECT COUNT(*) FROM embedding_imagen")
        count = cur.fetchone()[0]
        if count == 0:
            print("  - Tabla vacía, omitiendo índice.")
            conn.commit()
            return

        print(f"  ✓ Creando índice sobre {count} embeddings...")
        cur.execute("""
            CREATE INDEX idx_ivfflat_emb_imagen
            ON embedding_imagen
            USING ivfflat (embedding vector_cosine_ops)
            WITH (lists = 10)
        """)
    conn.commit()
    print("[INFO] Índice listo.")


# ─────────────────────────────────────────────────────────────────────────────
# MAIN
# ─────────────────────────────────────────────────────────────────────────────


def main():
    print("=" * 60)
    print("  VECTORIZACIÓN MULTIMODAL — CLIP ViT-B/32")
    print("=" * 60)

    model, processor = load_clip()

    conn = get_connection()
    try:
        vectorize_imagenes(conn, model, processor)
        create_image_index(conn)
    finally:
        conn.close()

    print("\n[OK] Vectorización multimodal completa.")
    print("     Ya puedes usar los modos 4 y 5 en main.py")


if __name__ == "__main__":
    main()