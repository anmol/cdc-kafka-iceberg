import boto3
import json
import time

# ---------------------------------------------
# Localstack Kinesis client
# ---------------------------------------------
# kinesis = boto3.client(
#     "kinesis",
#     region_name="us-east-1",
#     endpoint_url="http://localhost:4566",
#     aws_access_key_id="test",
#     aws_secret_access_key="test",
# )

kinesis = boto3.client(
    "kinesis",
    region_name="ap-southeast-1"
)


# Helper: read records from a stream
# ---------------------------------------------
def read_stream(stream, limit=10, start="TRIM_HORIZON"):
    """
    Reads messages from a Kinesis stream for debugging.
    start = "TRIM_HORIZON" or "LATEST"
    limit = how many messages to print
    """
    print(f"\n📥 Reading from stream: {stream} (start={start})\n")

    # 1. Get shard ID
    resp = kinesis.describe_stream(StreamName=stream)
    shard_id = resp["StreamDescription"]["Shards"][0]["ShardId"]

    # 2. Get iterator
    it_resp = kinesis.get_shard_iterator(
        StreamName=stream,
        ShardId=shard_id,
        ShardIteratorType=start,
    )

    shard_iterator = it_resp["ShardIterator"]

    count = 0

    while count < limit:
        out = kinesis.get_records(ShardIterator=shard_iterator, Limit=10)
        shard_iterator = out["NextShardIterator"]

        records = out.get("Records", [])
        if not records:
            time.sleep(0.3)
            continue

        for rec in records:
            raw = rec["Data"]
            try:
                decoded = json.loads(raw.decode("utf-8"))
            except Exception:
                decoded = raw.decode("utf-8")

            print(f"[{count+1}] {decoded}")
            count += 1

            if count >= limit:
                break

        time.sleep(0.2)

    print("\n✔ Done reading.\n")


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--stream", type=str, required=True, help="Kinesis stream name")
    parser.add_argument("--limit", type=int, default=10, help="Number of messages to read")
    parser.add_argument("--start", type=str, default="TRIM_HORIZON", help="Shard iterator type: TRIM_HORIZON or LATEST")
    args = parser.parse_args()
    read_stream(args.stream, limit=args.limit, start=args.start)