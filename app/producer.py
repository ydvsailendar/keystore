import os
import json
import time
import random
import logging
from confluent_kafka import Producer

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s"
)

KAFKA_BROKER = os.getenv("KAFKA_BROKER", "kafka:9092")
TOPIC = "worker-keystrokes"

producer_conf = {
    'bootstrap.servers': KAFKA_BROKER,
    'acks': 'all',                 # Wait for all replicas to ack for durability
    'retries': 5,                  # Retry sending message on failure
    'linger.ms': 10,               # Batch messages for 10 ms before sending
    'enable.idempotence': True,    # Avoid duplicate messages on retries
    'max.in.flight.requests.per.connection': 5
}

producer = Producer(producer_conf)

def delivery_report(err, msg):
    if err is not None:
        logging.error(f"Message delivery failed: {err}")
    else:
        logging.info(f"Message delivered to {msg.topic()} [{msg.partition()}] offset {msg.offset()}")

WORKERS = ['worker_1', 'worker_2', 'worker_3']

try:
    while True:
        worker_id = random.choice(WORKERS)
        keystroke_count = random.randint(1, 10)
        event = {
            'workerId': worker_id,
            'count': keystroke_count,
            'timestamp': int(time.time())
        }
        producer.produce(TOPIC, json.dumps(event).encode('utf-8'), callback=delivery_report)
        # Poll to serve delivery reports (call callbacks)
        producer.poll(0.1)  
        time.sleep(1)
except KeyboardInterrupt:
    logging.info("Stopping producer...")
finally:
    producer.flush()
    logging.info("Producer flushed and closed")
