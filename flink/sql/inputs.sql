CREATE TABLE orders (
  order_id INT,
  product_id INT,
  order_time TIMESTAMP(3),
  WATERMARK FOR order_time AS order_time - INTERVAL '24' HOUR
) WITH (
  'connector' = 'kinesis',
  'aws.region' = '${aws.region}',
  'format' = 'json',
  'json.fail-on-missing-field' = 'false',
  'json.ignore-parse-errors' = 'true',
  'json.timestamp-format.standard' = 'ISO-8601',
  'stream.arn' = '${stream.arn}'
)

CREATE TABLE products (
    product_id INT,
    product_name VARCHAR,
    product_price DOUBLE,
    update_time TIMESTAMP(3),
    WATERMARK FOR update_time AS update_time - INTERVAL '24' HOUR
) WITH (
  'connector' = 'kinesis',
  'aws.region' = '${aws.region}',
  'format' = 'json',
  'json.fail-on-missing-field' = 'false',
  'json.ignore-parse-errors' = 'true',
  'json.timestamp-format.standard' = 'ISO-8601',
  'stream.arn' = '${stream.arn}'
)


CREATE TABLE receipts (
  receipt_id INT,
  order_id INT,
  receipt_time TIMESTAMP(3),
  WATERMARK FOR receipt_time AS receipt_time - INTERVAL '24' HOUR
) WITH (
  'connector' = 'kinesis',
  'aws.region' = '${aws.region}',
  'format' = 'json',
  'json.fail-on-missing-field' = 'false',
  'json.ignore-parse-errors' = 'true',
  'json.timestamp-format.standard' = 'ISO-8601',
  'stream.arn' = '${stream.arn}'
)