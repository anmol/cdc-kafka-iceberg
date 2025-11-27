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
    --cli-binary-format raw-in-base64-out \
    --data $DATA
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
  "update_time": "$(printf "%s.%03dZ" \
  "$(date -u +"%Y-%m-%dT%H:%M:%S")" \
  "$((RANDOM % 1000))")"
}
EOF
)
  put "product-stream" "$DATA"
done
### -----------------------
### 2. Seed ORDERS (main table)
### -----------------------
echo "Seeding order-stream..."
ORDER_IDS=(101 102 103 104 105)
index=1
for oid in "${ORDER_IDS[@]}"; do
  product=$(( (index % 5) + 1 ))
  index=$((index + 1))
  DATA=$(cat <<EOF
{
  "order_id": $oid,
  "product_id": $product,
  "order_time": "$(printf "%s.%03dZ" \
  "$(date -u +"%Y-%m-%dT%H:%M:%S")" \
  "$((RANDOM % 1000))")"
}
EOF
)
  put "order-stream" "$DATA"
done
### -----------------------
### 3. Seed RECEIPTS (2 per order)
### -----------------------
echo "Seeding receipt-stream..."
for oid in "${ORDER_IDS[@]}"; do
  # Receipt 1
  DATA1=$(cat <<EOF
{
  "receipt_id": ${oid}01,
  "order_id": $oid,
  "receipt_time": "$(printf "%s.%03dZ" \
  "$(date -u +"%Y-%m-%dT%H:%M:%S")" \
  "$((RANDOM % 1000))")"
}
EOF
)
  put "receipt-stream" "$DATA1"
  # Receipt 2
  DATA2=$(cat <<EOF
{
  "receipt_id": ${oid}02,
  "order_id": $oid,
  "receipt_time": "$(printf "%s.%03dZ" \
  "$(date -u +"%Y-%m-%dT%H:%M:%S")" \
  "$((RANDOM % 1000))")"
}
EOF
)
  put "receipt-stream" "$DATA2"
done
echo "Done seeding all Kinesis streams with JOIN-ready data."
