import sqlite3
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List

app = FastAPI()
DB_PATH = '/app/db/keystrokes.db'

class WorkerKeystroke(BaseModel):
    worker_id: str
    keystrokes: int

def get_db_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

@app.get("/aggregates", response_model=List[WorkerKeystroke])
def read_aggregates():
    conn = get_db_connection()
    cursor = conn.execute("SELECT worker_id, keystrokes FROM aggregates")
    rows = cursor.fetchall()
    conn.close()
    if not rows:
        raise HTTPException(status_code=404, detail="No data found")
    return [WorkerKeystroke(worker_id=row['worker_id'], keystrokes=row['keystrokes']) for row in rows]
