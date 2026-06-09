import psycopg2
from psycopg2.extras import RealDictCursor
from config import DB_CONFIG


def get_connection():
    """Devuelve una conexión abierta a PostgreSQL."""
    return psycopg2.connect(**DB_CONFIG)


def get_cursor(conn):
    """Devuelve un cursor que retorna filas como diccionarios."""
    return conn.cursor(cursor_factory=RealDictCursor)