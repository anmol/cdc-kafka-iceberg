# IP = $(hostname -I | cut -d ' ' -f 1)
# IP=$(ipconfig getifaddr en0)
# change hostname accordingly
# to delete: 
# curl -X DELETE http://localhost:8083/connectors/cdc-using-debezium-connector
curl --location 'http://localhost:8083/connectors' \
   --header 'Accept: application/json' \
   --header 'Content-Type: application/json' \
   --data '{
   "name": "cdc-using-debezium-connector",
   "config": {
       "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
       "database.hostname": "10.10.180.82",
       "database.port": "5443",
       "database.user": "postgres",
       "database.password": "123",
       "database.dbname": "cdc",
       "database.server.id": "184054",
       "table.include.list": "public.User,public.employee",
       "topic.creation.default.partitions": "1",
       "topic.creation.default.replication.factor": "1",
       "slot.name": "kafka_poc",
       "slot.max.retries": "2",
       "tasks.max":"1",
       "topic.prefix": "cdc",
       "plugin.name": "pgoutput"
   }
}'
