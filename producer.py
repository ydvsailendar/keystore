import os
import json
import time
import random
from confluent_kafka import Producer

KAFKA_BROKER = os.getenv("KAFKA_BROKER", "kafka:9092")
TOPIC = "worker-keystrokes"

producer_conf = {'bootstrap.servers': KAFKA_BROKER}
producer = Producer(producer_conf)

WORKERS = ['worker_1', 'worker_2', 'worker_3']

def delivery_report(err, msg):
    if err:
        print(f"Message delivery failed: {err}")
    else:
        print(f"Message delivered to {msg.topic()} [{msg.partition()}]")

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
        producer.poll(0)  # serve delivery reports async
        time.sleep(1)
except KeyboardInterrupt:
    print("Stopping producer...")
finally:
    producer.flush()
