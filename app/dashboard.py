import logging
from fastapi import FastAPI, HTTPException
from fastapi.responses import HTMLResponse
from pydantic import BaseModel
from typing import List
from sqlalchemy import create_engine, select
from sqlalchemy.engine import URL
import os
from models import aggregates

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s"
)

app = FastAPI()

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

class WorkerKeystroke(BaseModel):
    worker_id: str
    keystrokes: int

@app.get("/aggregates", response_model=List[WorkerKeystroke])
def read_aggregates():
    logging.info("GET /aggregates called")
    with engine.connect() as conn:
        query = select(aggregates.c.worker_id, aggregates.c.keystrokes)
        logging.debug(f"Executing query: {query}")
        result = conn.execute(query).fetchall()
    if not result:
        logging.warning("No data found in aggregates table")
        raise HTTPException(status_code=404, detail="No data found")
    logging.info(f"Returning {len(result)} records from aggregates")
    return [WorkerKeystroke(worker_id=row.worker_id, keystrokes=row.keystrokes) for row in result]

@app.get("/", response_class=HTMLResponse)
def read_aggregates_ui():
    logging.info("GET / (UI) called")
    with engine.connect() as conn:
        query = select(aggregates.c.worker_id, aggregates.c.keystrokes)
        logging.debug(f"Executing query: {query}")
        rows = conn.execute(query).fetchall()
    if not rows:
        logging.warning("No data found in aggregates table for UI")
        html_content = "<h2>No data found</h2>"
    else:
        rows_html = "".join(
            f"<tr><td>{row.worker_id}</td><td>{row.keystrokes}</td></tr>"
            for row in rows
        )
        html_content = f"""
        <html>
        <head>
            <title>Keystroke Aggregates</title>
            <style>
                body {{
                    font-family: Arial, sans-serif;
                    margin: 40px;
                    background: #f7f7f7;
                }}
                table {{
                    border-collapse: collapse;
                    width: 50%;
                    margin: auto;
                    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                    background: white;
                }}
                th, td {{
                    border: 1px solid #ddd;
                    padding: 12px;
                    text-align: center;
                }}
                th {{
                    background-color: #4CAF50;
                    color: white;
                }}
                tr:nth-child(even) {{background-color: #f2f2f2;}}
                h2 {{
                    text-align: center;
                    color: #333;
                }}
            </style>
        </head>
        <body>
            <h2>Keystroke Aggregates</h2>
            <table>
                <thead>
                    <tr>
                        <th>Worker ID</th>
                        <th>Keystrokes</th>
                    </tr>
                </thead>
                <tbody>
                    {rows_html}
                </tbody>
            </table>
        </body>
        </html>
        """
    return HTMLResponse(content=html_content)
