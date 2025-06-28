import os
import json
import time
import logging
from collections import defaultdict
from confluent_kafka import Consumer, KafkaError
from sqlalchemy import create_engine
from sqlalchemy.dialects.postgresql import insert
from sqlalchemy.engine import URL
from sqlalchemy.exc import SQLAlchemyError
from tenacity import retry, stop_after_attempt, wait_fixed
from models import aggregates

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s"
)

POSTGRES_USER = os.getenv("POSTGRES_USER")
POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD")
POSTGRES_HOST = os.getenv("POSTGRES_HOST")
POSTGRES_DB = os.getenv("POSTGRES_DB")
POSTGRES_PORT = os.getenv("POSTGRES_PORT")

KAFKA_BROKER = os.getenv("KAFKA_BROKER", "kafka:9092")
TOPIC = "worker-keystrokes"

url = URL.create(
    "postgresql+psycopg2",
    username=POSTGRES_USER,
    password=POSTGRES_PASSWORD,
    host=POSTGRES_HOST,
    port=int(POSTGRES_PORT),
    database=POSTGRES_DB,
)

engine = create_engine(url)

consumer_conf = {
    'bootstrap.servers': KAFKA_BROKER,
    'group.id': 'activity-monitor',
    'auto.offset.reset': 'earliest',
    'enable.auto.commit': False,
    'max.poll.interval.ms': 300000,  # 5 min max processing time per poll
    'session.timeout.ms': 10000,
    'fetch.max.bytes': 1048576,      # 1MB max per fetch
    'max.poll.records': 1000,        # max 1000 messages per poll batch
    'enable.partition.eof': False    # EOF events off (optional)
}

consumer = Consumer(consumer_conf)
consumer.subscribe([TOPIC])

WINDOW_DURATION = 60  # seconds
window_start = time.time()

@retry(stop=stop_after_attempt(3), wait=wait_fixed(2))
def save_aggregates_to_db(aggregates_dict):
    logging.info(f"Saving {len(aggregates_dict)} aggregate records to DB")
    with engine.begin() as conn:
        for worker, count in aggregates_dict.items():
            if count <= 0:
                logging.warning(f"Skipping non-positive count for {worker}: {count}")
                continue
            stmt = insert(aggregates).values(worker_id=worker, keystrokes=count)
            stmt = stmt.on_conflict_do_update(
                index_elements=['worker_id'],
                set_={'keystrokes': aggregates.c.keystrokes + stmt.excluded.keystrokes}
            )
            conn.execute(stmt)
    logging.info("Save to DB complete")

def process_messages(msgs):
    keystroke_counts = defaultdict(int)
    for msg in msgs:
        if msg.error():
            if msg.error().code() == KafkaError._PARTITION_EOF:
                continue  # Ignore EOF
            logging.error(f"Kafka message error: {msg.error()}")
            continue
        try:
            event = json.loads(msg.value())
            worker = event['workerId']
            count = event['count']
            if count <= 0:
                logging.warning(f"Skipping non-positive count from message for {worker}: {count}")
                continue
            keystroke_counts[worker] += count
        except Exception as e:
            logging.exception(f"Failed to process message: {msg.value()}. Error: {e}")
    return keystroke_counts

try:
    aggregate_counts = defaultdict(int)
    while True:
        msgs = consumer.consume(num_messages=consumer_conf['max.poll.records'], timeout=1.0)
        if not msgs:
            continue

        batch_counts = process_messages(msgs)
        for k, v in batch_counts.items():
            aggregate_counts[k] += v

        now = time.time()
        if now - window_start >= WINDOW_DURATION:
            if aggregate_counts:
                logging.info(f"⏳ Window elapsed, saving aggregates: {dict(aggregate_counts)}")
                try:
                    save_aggregates_to_db(aggregate_counts)
                    consumer.commit()
                except SQLAlchemyError as db_err:
                    logging.exception(f"DB write failed, skipping commit: {db_err}")
                aggregate_counts.clear()
            window_start = now

except KeyboardInterrupt:
    logging.info("👋 Shutting down consumer")

finally:
    try:
        consumer.commit()
        logging.info("✅ Final Kafka commit done")
    except Exception as e:
        logging.warning(f"⚠️ Kafka final commit failed: {e}")
    consumer.close()
    logging.info("✅ Consumer closed")
