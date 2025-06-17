import sqlite3

conn = sqlite3.connect('/app/db/keystrokes.db')
conn.execute('''
CREATE TABLE IF NOT EXISTS aggregates (
    worker_id TEXT PRIMARY KEY,
    keystrokes INTEGER NOT NULL
)
''')
conn.commit()
conn.close()
