# =====================================================
# chunking.py — Estrategias de chunking para el pipeline RAG
#
# Implementa las dos estrategias definidas en la Sección 5:
#   1. Paragraph-Aware  → sinopsis y descripciones
#   2. Fixed-Size       → reseñas de usuarios
# =====================================================

from config import (
    CHUNK_SIZE_PARAGRAPH,
    CHUNK_OVERLAP_PARAGRAPH,
    CHUNK_SIZE_FIXED,
    CHUNK_OVERLAP_FIXED,
)


def _split_by_tokens(text: str, chunk_size: int, overlap: int) -> list[str]:
    """
    División por ventana deslizante de tokens (palabras).
    Aproximación simple: token ≈ palabra (suficiente para all-MiniLM-L6-v2).
    """
    words = text.split()
    chunks = []
    start = 0
    while start < len(words):
        end = min(start + chunk_size, len(words))
        chunks.append(" ".join(words[start:end]))
        if end == len(words):
            break
        start += chunk_size - overlap
    return [c for c in chunks if c.strip()]


def chunk_paragraph_aware(text: str) -> list[str]:
    """
    Estrategia Paragraph-Aware:
    Divide por párrafos (\\n\\n). Si un párrafo supera chunk_size,
    se subdivide con ventana deslizante.
    Usada para: contenido_textual (sinopsis, descripcion).
    """
    paragraphs = [p.strip() for p in text.split("\n\n") if p.strip()]
    chunks = []
    for para in paragraphs:
        words = para.split()
        if len(words) <= CHUNK_SIZE_PARAGRAPH:
            chunks.append(para)
        else:
            chunks.extend(_split_by_tokens(para, CHUNK_SIZE_PARAGRAPH, CHUNK_OVERLAP_PARAGRAPH))
    return chunks


def chunk_fixed_size(text: str) -> list[str]:
    """
    Estrategia Fixed-Size (ventana deslizante):
    Para textos sin estructura clara (reseñas de usuarios).
    """
    return _split_by_tokens(text, CHUNK_SIZE_FIXED, CHUNK_OVERLAP_FIXED)


def chunk_text(text: str, strategy: str = "paragraph") -> list[str]:
    """
    Punto de entrada unificado.
    strategy: 'paragraph' (sinopsis/descripciones) | 'fixed' (reseñas)
    """
    if strategy == "paragraph":
        return chunk_paragraph_aware(text)
    elif strategy == "fixed":
        return chunk_fixed_size(text)
    else:
        raise ValueError(f"Estrategia desconocida: '{strategy}'. Usar 'paragraph' o 'fixed'.")


# ─── Prueba rápida ────────────────────────────────────────────────────────────
if __name__ == "__main__":
    texto_prueba = (
        "En un futuro donde la Tierra agoniza, Cooper lidera una misión espacial.\n\n"
        "Atraviesan un agujero de gusano cerca de Saturno buscando planetas habitables.\n\n"
        "La dilatación temporal los separa de sus familias durante décadas."
    )
    print("=== Paragraph-Aware ===")
    for i, chunk in enumerate(chunk_paragraph_aware(texto_prueba), 1):
        print(f"  Chunk {i}: {chunk[:80]}...")

    resena_prueba = (
        "Una película que te hace replantearte la naturaleza del tiempo y el amor. "
        "La escena del agujero negro es visualmente impresionante y científicamente "
        "fundamentada. La actuación de McConaughey es soberbia."
    )
    print("\n=== Fixed-Size ===")
    for i, chunk in enumerate(chunk_fixed_size(resena_prueba), 1):
        print(f"  Chunk {i}: {chunk[:80]}...")