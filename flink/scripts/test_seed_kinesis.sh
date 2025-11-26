#!/usr/bin/env zsh
set -e

AWS="aws-local"   # alias for 'aws --profile=localstack --endpoint-url=http://localhost:4566'
echo "Seeding Kinesis streams for JOIN testing..."
### -----------------------
### Helper: Put record
### -----------------------
put() {
  STREAM=$1
  DATA=$2
  echo "  → ${STREAM}: ${DATA}"
  aws-local kinesis put-record \
    --stream-name "$STREAM" \
    --partition-key "pk-1" \
    --data "$(echo -n $DATA | base64)"
}
### -----------------------
### 1. Seed PRODUCTS
### -----------------------
echo "Seeding product-stream..."
for pid in {1..5}; do
  DATA=$(cat <<EOF
{
  "product_id": $pid,
  "product_name": "Product-$pid",
  "product_price": $(echo "$pid * 10" | bc -l),
  "update_time": "$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")"
}
EOF
)
  put "product-stream" "$DATA"
done
echo "Done seeding all Kinesis streams with JOIN-ready data."
