# IP = $(hostname -I | cut -d ' ' -f 1)
# change hostname accordingly
# $1 = bucket name (without s3://)
# $2 = access key id
# $3 = secret access key
# $4 = session token
curl --location 'http://localhost:8083/connectors' \
   --header 'Accept: application/json' \
   --header 'Content-Type: application/json' \
   --data '{
   "name": "kafka-connect-iceberg",
   "config": {
        "connector.class": "io.tabular.iceberg.connect.IcebergSinkConnector",
        "tasks.max": "2",
        "errors.log.enable": "true",
        "topics.regex": "cdc.*",
        
        "transforms": "debezium",
        "transforms.debezium.type": "io.tabular.iceberg.connect.transforms.DebeziumTransform",
        "transforms.debezium.cdc.target.pattern": "cdc.{db}_{table}",

        "iceberg.catalog.warehouse": "s3://'"$1"'/anmol/kafka/out/apg_test",

        "iceberg.catalog.catalog-impl": "org.apache.iceberg.aws.glue.GlueCatalog",
        "iceberg.catalog.io-impl": "org.apache.iceberg.aws.s3.S3FileIO",
        "iceberg.catalog.s3.access-key-id": "'"$2"'",
        "iceberg.catalog.s3.secret-access-key": "'"$3"'",
        "iceberg.catalog.s3.session-token": "'"$4"'",
        "iceberg.catalog.client.region": "ap-southeast-1",

        "iceberg.tables.cdc-field": "_cdc.op",
        "iceberg.tables.route-field": "_cdc.target",
        "iceberg.tables.dynamic-enabled": "true",
        "iceberg.tables.upsert-mode-enabled": "true",
        "iceberg.tables.evolve-schema-enabled": "true",
        "iceberg.tables.auto-create-enabled": "true",
        "iceberg.tables.schema-case-insensitive": "true",
        "iceberg.control.commit.interval-ms": "10000",
        "iceberg.control.commit.timeout-ms": "60000",
        "iceberg.kafka.heartbeat.interval.ms": "30000",
        "iceberg.kafka.session.timeout.ms": "90000",

        "iceberg.table.cdc.public_user.id-columns": "id",
        "iceberg.table.cdc.public_employee.id-columns": "id",
        "iceberg.table.cdc.public_employee_2.id-columns": "id",
        "iceberg.table.cdc.public_employee_3.id-columns": "id"
   }
}'
