import os
import json
import time
import sqlite3
from collections import defaultdict
from confluent_kafka import Consumer

KAFKA_BROKER = os.getenv("KAFKA_BROKER", "kafka:9092")
TOPIC = "worker-keystrokes"
DB_PATH = '/app/db/keystrokes.db'

consumer_conf = {
    'bootstrap.servers': KAFKA_BROKER,
    'group.id': 'activity-monitor',
    'auto.offset.reset': 'earliest'
}

consumer = Consumer(consumer_conf)
consumer.subscribe([TOPIC])

keystroke_counts = defaultdict(int)
window_start = time.time()
WINDOW_DURATION = 60  # seconds

def save_aggregates_to_db(aggregates):
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    for worker, count in aggregates.items():
        cursor.execute('''
            INSERT INTO aggregates(worker_id, keystrokes) VALUES (?, ?)
            ON CONFLICT(worker_id) DO UPDATE SET keystrokes=excluded.keystrokes
        ''', (worker, count))
    conn.commit()
    conn.close()

try:
    while True:
        msg = consumer.poll(1.0)
        if msg is None:
            continue
        if msg.error():
            print(f"Error: {msg.error()}")
            continue

        event = json.loads(msg.value())
        worker = event['workerId']
        keystroke_counts[worker] += event['count']

        now = time.time()
        if now - window_start >= WINDOW_DURATION:
            print(f"Saving aggregates: {dict(keystroke_counts)}")
            save_aggregates_to_db(keystroke_counts)
            keystroke_counts.clear()
            window_start = now

finally:
    consumer.close()
