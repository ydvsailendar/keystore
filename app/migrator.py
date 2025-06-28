from sqlalchemy import create_engine
from sqlalchemy.engine import URL
import os
from models import metadata

POSTGRES_USER = os.getenv("POSTGRES_USER")
POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD")
POSTGRES_HOST = os.getenv("POSTGRES_HOST")
POSTGRES_DB = os.getenv("POSTGRES_DB")
POSTGRES_PORT = os.getenv("POSTGRES_PORT")

url = URL.create(
    "postgresql+psycopg2",
    username=POSTGRES_USER,
    password=POSTGRES_PASSWORD,
    host=POSTGRES_HOST,
    port=int(POSTGRES_PORT),
    database=POSTGRES_DB,
)

engine = create_engine(url)

def run_migrations():
    metadata.create_all(engine)
    print("Migration complete: Table 'aggregates' ensured.")

if __name__ == "__main__":
    run_migrations()
