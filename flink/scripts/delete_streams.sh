#!/usr/bin/env bash

set -e

aws-local kinesis delete-stream --stream-name product-stream
aws-local kinesis delete-stream --stream-name order-stream
aws-local kinesis delete-stream --stream-name receipt-stream
aws-local kinesis delete-stream --stream-name enriched-orders-stream