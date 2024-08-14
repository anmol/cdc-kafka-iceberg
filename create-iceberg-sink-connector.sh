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
        "errors.log.enable": "true",
        "topics.regex": "cdc.*",
        
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
        "iceberg.tables.schema-case-insensitive": "true",
        "iceberg.control.commit.interval-ms": "5000",
        "iceberg.control.commit.timeout-ms": "600000",
        "consumer.override.auto.offset.reset": "earliest",
        "iceberg.kafka.auto.offset.reset": "earliest",
        "iceberg.kafka.heartbeat.interval.ms": "30000",
        "iceberg.kafka.session.timeout.ms": "90000",

        "iceberg.table.cdc.public_user.id-columns": "id",
        "iceberg.table.cdc.public_employee.id-columns": "id"
   }
}'
