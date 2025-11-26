#!/usr/bin/env zsh

set -e

ITER=$(aws-local kinesis get-shard-iterator \
  --stream-name $1 \
  --shard-iterator-type TRIM_HORIZON \
  --shard-id shardId-000000000000 \
  --query 'ShardIterator' --output text)

while true; do
  OUTPUT=$(aws-local kinesis get-records --shard-iterator "$ITER")
  echo "$OUTPUT" | jq '.Records[].Data | @base64d'
  ITER=$(echo "$OUTPUT" | jq -r '.NextShardIterator')
  sleep 1
done