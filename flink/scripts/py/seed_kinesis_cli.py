#!/usr/bin/env python3
import boto3
import json
from datetime import datetime

# ---------------------------------------------
# Kinesis client
# ---------------------------------------------

kinesis = boto3.client(
    "kinesis",
    region_name="ap-southeast-1"
)


# ---------------------------------------------
# Helper: put a record
# ---------------------------------------------
def put(stream, data):
    print(f" → {stream}: {data}")
    kinesis.put_record(
        StreamName=stream,
        Data=json.dumps(data),
        PartitionKey="pk-1"
    )
    

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--stream", type=str, required=True, help="Kinesis stream name")
    parser.add_argument("--data", type=str, required=True, help="message to put")
    args = parser.parse_args()
    data = json.loads(args.data)
    data['created_at'] = datetime.now().isoformat()
    put(args.stream, data)