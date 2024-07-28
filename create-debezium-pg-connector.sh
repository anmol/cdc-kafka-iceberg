# IP = $(hostname -I | cut -d ' ' -f 1)
# change hostname accordingly
curl --location 'http://localhost:8083/connectors' \
   --header 'Accept: application/json' \
   --header 'Content-Type: application/json' \
   --data '{
   "name": "cdc-using-debezium-connector",
   "config": {
       "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
       "database.hostname": "192.168.1.11",
       "database.port": "5443",
       "database.user": "postgres",
       "database.password": "123",
       "database.dbname": "cdc-using-debezium",
       "database.server.id": "184054",
       "table.include.list": "public.User",
       "topic.prefix": "cdc-using-debezium-topic"
   }
}'
