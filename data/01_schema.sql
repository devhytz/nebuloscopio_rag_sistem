-- =====================================================
-- ESQUEMA RELACIONAL - PLATAFORMA STREAMING RAG
-- Ejecutar en PostgreSQL con la extensión pgvector instalada
-- Orden: 01_schema.sql → 02_seed.sql → (luego python)
-- =====================================================

-- Extensión vectorial (requiere pgvector instalado)
CREATE EXTENSION IF NOT EXISTS vector;

-- ─── CATÁLOGOS BASE ────────────────────────────────────────────────────────

CREATE TABLE pais (
    id_pais  SERIAL PRIMARY KEY,
    nombre   VARCHAR(100) NOT NULL
);

CREATE TABLE idioma (
    id_idioma  SERIAL PRIMARY KEY,
    nombre     VARCHAR(100) NOT NULL
);

CREATE TABLE genero (
    id_genero  SERIAL PRIMARY KEY,
    nombre     VARCHAR(100) NOT NULL
);

CREATE TABLE productora (
    id_productora  SERIAL PRIMARY KEY,
    nombre         VARCHAR(150) NOT NULL
);

CREATE TABLE rol (
    id_rol  SERIAL PRIMARY KEY,
    nombre  VARCHAR(100) NOT NULL
);

CREATE TABLE persona (
    id_persona        SERIAL PRIMARY KEY,
    nombre            VARCHAR(150) NOT NULL,
    fecha_nacimiento  DATE,
    nacionalidad      VARCHAR(100)
);

-- ─── USUARIOS ──────────────────────────────────────────────────────────────

CREATE TABLE usuario (
    id_usuario  SERIAL PRIMARY KEY,
    nombre      VARCHAR(150) NOT NULL,
    email       VARCHAR(150) UNIQUE NOT NULL
);

-- ─── PELÍCULAS Y RELACIONES ────────────────────────────────────────────────

CREATE TABLE pelicula (
    id_pelicula        SERIAL PRIMARY KEY,
    titulo             VARCHAR(200) NOT NULL,
    fecha_lanzamiento  DATE,
    duracion           INT,          -- minutos
    id_pais            INT,
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
);

CREATE TABLE pelicula_genero (
    id_pelicula  INT,
    id_genero    INT,
    PRIMARY KEY (id_pelicula, id_genero),
    FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula),
    FOREIGN KEY (id_genero)   REFERENCES genero(id_genero)
);

CREATE TABLE pelicula_idioma (
    id_pelicula  INT,
    id_idioma    INT,
    tipo         VARCHAR(50),  -- 'original', 'doblado', 'subtitulado'
    PRIMARY KEY (id_pelicula, id_idioma, tipo),
    FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula),
    FOREIGN KEY (id_idioma)   REFERENCES idioma(id_idioma)
);

CREATE TABLE pelicula_productora (
    id_pelicula   INT,
    id_productora INT,
    PRIMARY KEY (id_pelicula, id_productora),
    FOREIGN KEY (id_pelicula)   REFERENCES pelicula(id_pelicula),
    FOREIGN KEY (id_productora) REFERENCES productora(id_productora)
);

CREATE TABLE participacion (
    id_pelicula  INT,
    id_persona   INT,
    id_rol       INT,
    personaje    VARCHAR(150),
    PRIMARY KEY (id_pelicula, id_persona, id_rol),
    FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula),
    FOREIGN KEY (id_persona)  REFERENCES persona(id_persona),
    FOREIGN KEY (id_rol)      REFERENCES rol(id_rol)
);

-- ─── CONTENIDO TEXTUAL (vectorizable) ─────────────────────────────────────

CREATE TABLE contenido_textual (
    id_contenido  SERIAL PRIMARY KEY,
    id_pelicula   INT NOT NULL,
    tipo          VARCHAR(50),   -- 'sinopsis', 'descripcion'
    texto         TEXT,
    FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula)
);
CREATE INDEX idx_contenido_pelicula ON contenido_textual(id_pelicula);

CREATE TABLE imagen (
    id_imagen    SERIAL PRIMARY KEY,
    id_pelicula  INT NOT NULL,
    url          TEXT,
    tipo         VARCHAR(50),
    FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula)
);

CREATE TABLE banda_sonora (
    id_banda     SERIAL PRIMARY KEY,
    id_pelicula  INT NOT NULL,
    nombre       VARCHAR(150),
    FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula)
);

CREATE TABLE cancion (
    id_cancion  SERIAL PRIMARY KEY,
    id_banda    INT NOT NULL,
    nombre      VARCHAR(150),
    duracion    INT,  -- segundos
    FOREIGN KEY (id_banda) REFERENCES banda_sonora(id_banda)
);

-- ─── PIPELINE RAG ──────────────────────────────────────────────────────────

CREATE TABLE consulta (
    id_consulta  SERIAL PRIMARY KEY,
    id_usuario   INT NOT NULL,
    texto        TEXT,
    fecha        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);
CREATE INDEX idx_consulta_usuario ON consulta(id_usuario);

CREATE TABLE respuesta (
    id_respuesta  SERIAL PRIMARY KEY,
    id_consulta   INT NOT NULL,
    texto         TEXT,
    contexto      TEXT,
    FOREIGN KEY (id_consulta) REFERENCES consulta(id_consulta)
);

-- CORRECCIÓN: FK apunta a id_consulta (trazabilidad del pipeline RAG)
CREATE TABLE resultado_busqueda (
    id_resultado    SERIAL PRIMARY KEY,
    id_consulta     INT NOT NULL,
    id_pelicula     INT NOT NULL,
    score_similitud NUMERIC(5,4),
    fecha           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_consulta)  REFERENCES consulta(id_consulta),
    FOREIGN KEY (id_pelicula)  REFERENCES pelicula(id_pelicula)
);
CREATE INDEX idx_resultado_consulta ON resultado_busqueda(id_consulta);

-- ─── INTERACCIÓN DE USUARIOS ───────────────────────────────────────────────

CREATE TABLE resena (
    id_resena    SERIAL PRIMARY KEY,
    id_usuario   INT NOT NULL,
    id_pelicula  INT NOT NULL,
    texto        TEXT,
    calificacion INT CHECK (calificacion BETWEEN 1 AND 5),
    fecha        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario)  REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula)
);
CREATE INDEX idx_resena_usuario  ON resena(id_usuario);
CREATE INDEX idx_resena_pelicula ON resena(id_pelicula);

CREATE TABLE visualizacion (
    id_usuario    INT,
    id_pelicula   INT,
    tiempo_actual INT,            -- segundos
    completada    BOOLEAN DEFAULT FALSE,
    fecha_ultima  TIMESTAMP,
    PRIMARY KEY (id_usuario, id_pelicula),
    FOREIGN KEY (id_usuario)  REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula)
);
CREATE INDEX idx_visualizacion_usuario ON visualizacion(id_usuario);

CREATE TABLE favorito (
    id_usuario   INT,
    id_pelicula  INT,
    fecha        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_pelicula),
    FOREIGN KEY (id_usuario)  REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula)
);

CREATE TABLE recomendacion (
    id_recomendacion  SERIAL PRIMARY KEY,
    id_usuario        INT NOT NULL,
    id_pelicula       INT NOT NULL,
    motivo            TEXT,
    score             NUMERIC(5,4),
    fecha             TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario)  REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula)
);

-- ─── TABLAS VECTORIALES (pgvector) ─────────────────────────────────────────
-- Dimensión 384 corresponde a all-MiniLM-L6-v2

CREATE TABLE embedding_contenido (
    id_embedding  SERIAL PRIMARY KEY,
    id_contenido  INT NOT NULL UNIQUE,
    embedding     VECTOR(384),
    FOREIGN KEY (id_contenido) REFERENCES contenido_textual(id_contenido)
);

CREATE TABLE embedding_resena (
    id_embedding  SERIAL PRIMARY KEY,
    id_resena     INT NOT NULL UNIQUE,
    embedding     VECTOR(384),
    FOREIGN KEY (id_resena) REFERENCES resena(id_resena)
);

CREATE TABLE embedding_consulta (
    id_embedding  SERIAL PRIMARY KEY,
    id_consulta   INT NOT NULL UNIQUE,
    embedding     VECTOR(384),
    FOREIGN KEY (id_consulta) REFERENCES consulta(id_consulta)
);

-- Los índices IVFFlat requieren datos previos para el entrenamiento.
-- Ejecutar DESPUÉS de poblar con 02_seed.sql y vectorize.py:
--
-- CREATE INDEX idx_emb_contenido ON embedding_contenido
--     USING ivfflat (embedding vector_cosine_ops) WITH (lists = 10);
--
-- CREATE INDEX idx_emb_resena ON embedding_resena
--     USING ivfflat (embedding vector_cosine_ops) WITH (lists = 10);
--
-- CREATE INDEX idx_emb_consulta ON embedding_consulta
--     USING ivfflat (embedding vector_cosine_ops) WITH (lists = 10);