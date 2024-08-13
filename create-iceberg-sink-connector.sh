# IP = $(hostname -I | cut -d ' ' -f 1)
# change hostname accordingly
curl --location 'http://localhost:8083/connectors' \
   --header 'Accept: application/json' \
   --header 'Content-Type: application/json' \
   --data '{
   "name": "kafka-connect-iceberg",
   "config": {
        "connector.class": "io.tabular.iceberg.connect.IcebergSinkConnector",
        "tasks.max": "1",
        "topics.regex": "cdc.*",
        "transaction.timeout.ms": "120000",
        "retries": "1",
        "max.block.ms": "120000",
        "errors.deadletterqueue.context.headers.enable": "false",
        "consumer.auto.offset.reset": "latest",
        "errors.log.enable": "true",
        "transforms": "debezium",
        "transforms.debezium.type": "io.tabular.iceberg.connect.transforms.DebeziumTransform",
        "transforms.debezium.cdc.target.pattern": "cdc.{db}_{table}",
        "iceberg.catalog.type": "hadoop",
        "iceberg.catalog.warehouse": "/out-kafka/iceberg/warehouse",
        "iceberg.tables.cdc-field": "_cdc.op",
        "iceberg.tables.route-field": "_cdc.target",
        "iceberg.tables.dynamic-enabled": "true",
        "iceberg.tables.upsert-mode-enabled": "true",
        "iceberg.tables.evolve-schema-enabled": "true",
        "iceberg.tables.auto-create-enabled": "true",
        "iceberg.control.commit.interval-ms": "10000",
        "iceberg.control.commit.timeout-ms": "60000",
        "iceberg.table.cdc.public_user.id-columns": "id",
        "key.converter": "org.apache.kafka.connect.json.JsonConverter",
        "value.converter": "org.apache.kafka.connect.json.JsonConverter",
        "key.converter.schemas.enable": "true",
        "value.converter.schemas.enable": "true",
        "retry.backoff.ms": "10000",
        "offset.flush.timeout.ms": "30000",
        "heartbeat.interval.ms": "20000",
        "session.timeout.ms": "70000"
   }
}'
