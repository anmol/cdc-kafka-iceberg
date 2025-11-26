#!/usr/bin/env zsh

set -e

aws-local kinesis create-stream --stream-name product-stream --shard-count 1
aws-local kinesis create-stream --stream-name order-stream --shard-count 1
aws-local kinesis create-stream --stream-name receipt-stream --shard-count 1
aws-local kinesis create-stream --stream-name enriched-orders-stream --shard-count 1
