# =====================================================
# config.py — Configuración central del proyecto
# Editar este archivo antes de ejecutar cualquier script
# =====================================================

# ─── BASE DE DATOS ─────────────────────────────────────────────────────────
DB_CONFIG = {
    "host": "ep-autumn-sound-ac5uosnd-pooler.sa-east-1.aws.neon.tech",
    "port": 5432,
    "dbname": "neondb",
    "user": "neondb_owner",
    "password": "npg_mq1jATPOp4Bf",
    "sslmode": "require"
}

# ─── MODELOS ────────────────────────────────────────────────────────────────

# Modelo de embeddings (sentence-transformers, corre local, sin costo)
EMBEDDING_MODEL = "sentence-transformers/all-MiniLM-L6-v2"
EMBEDDING_DIM   = 384   # Dimensión fija del modelo all-MiniLM-L6-v2

# Modelo LLM generativo (Ollama, corre local, sin costo)
# Requiere tener Ollama instalado: https://ollama.com
# y haber ejecutado: ollama pull llama3.2
OLLAMA_MODEL    = "llama3.2"
OLLAMA_URL      = "http://localhost:11434/api/generate"

# ─── CHUNKING ────────────────────────────────────────────────────────────────

# Estrategia Paragraph-Aware (para sinopsis y descripciones)
CHUNK_SIZE_PARAGRAPH    = 300   # tokens máximos por chunk
CHUNK_OVERLAP_PARAGRAPH = 50    # tokens de overlap entre chunks

# Estrategia Fixed-Size (para reseñas)
CHUNK_SIZE_FIXED        = 150
CHUNK_OVERLAP_FIXED     = 30

# ─── RAG ─────────────────────────────────────────────────────────────────────

# Número de chunks a recuperar por búsqueda vectorial
TOP_K = 3

SYSTEM_PROMPT = """
Eres un asistente de recomendación de películas basado en una base de datos vectorial.

REGLAS OBLIGATORIAS:

1. Responde únicamente usando la información presente en el CONTEXTO proporcionado.
2. No inventes películas, actores, directores, géneros ni información que no aparezca en el CONTEXTO.
3. No utilices conocimiento externo.
4. No hagas suposiciones.
5. Si la respuesta no puede obtenerse del CONTEXTO, responde exactamente:

"No encontré información suficiente en la base de datos para responder esa consulta."

6. Cuando recomiendes películas, solo puedes mencionar películas presentes en el CONTEXTO.
7. Explica brevemente por qué cada película es relevante para la consulta del usuario.
8. Mantén respuestas claras y concisas.
9. No infieras atributos subjetivos como:
- calidad
- tristeza
- felicidad
- belleza
- popularidad

a menos que estén explícitamente descritos en el contexto.
10. Si el usuario pregunta por características que no aparecen explícitamente en el contexto recuperado, indica que no existe información suficiente en la base de datos.
11. No afirmes diferencias o similitudes que no aparezcan explícitamente
en el contexto recuperado.
"""