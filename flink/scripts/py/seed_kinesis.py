#!/usr/bin/env python3
import boto3
import json
import random
from datetime import datetime, timezone

# ---------------------------------------------
# Localstack Kinesis client
# ---------------------------------------------
kinesis = boto3.client(
    "kinesis",
    region_name="us-east-1",
    endpoint_url="http://localhost:4566",
    aws_access_key_id="test",
    aws_secret_access_key="test",
)

kinesis_aws = boto3.client(
    "kinesis",
    region_name="ap-southeast-1"
)



# ---------------------------------------------
# Helper: generate ISO-8601 timestamp
# ---------------------------------------------
def iso_ts():
    now = datetime.now(timezone.utc)
    # add random milliseconds
    ms = random.randint(0, 999)
    # format manually because Python's %f gives 6 digits
    ts = now.strftime("%Y-%m-%dT%H:%M:%S")
    return f"{ts}.{ms:03d}Z"


# ---------------------------------------------
# Helper: put a record
# ---------------------------------------------
def put(stream, data):
    print(f" → {stream}: {data}")
    kinesis_aws.put_record(
        StreamName=stream,
        Data=json.dumps(data),
        PartitionKey="pk-1"
    )


# ---------------------------------------------
# 1. Seed PRODUCTS
# ---------------------------------------------
print("Seeding product-stream...")

for pid in range(1, 6):
    record = {
        "product_id": pid,
        "product_name": f"Product-{pid}",
        "product_price": float(pid * 10),
        "update_time": datetime.now().isoformat(),
    }
    put("product-stream", record)

# ---------------------------------------------
# 2. Seed ORDERS
# ---------------------------------------------
print("Seeding order-stream...")

ORDER_IDS = [101, 102, 103, 104, 105]

for i, oid in enumerate(ORDER_IDS):
    product = (i % 5) + 1
    record = {
        "order_id": oid,
        "product_id": product,
        "order_time": datetime.now().isoformat(),
    }
    put("order-stream", record)

# ---------------------------------------------
# 3. Seed RECEIPTS
# ---------------------------------------------
print("Seeding receipt-stream...")

for oid in ORDER_IDS:
    for suffix in (1, 2):
        receipt_id = int(f"{oid}0{suffix}")
        record = {
            "receipt_id": receipt_id,
            "order_id": oid,
            "receipt_time": datetime.now().isoformat(),
        }
        put("receipt-stream", record)

print("Done seeding all Kinesis streams.")