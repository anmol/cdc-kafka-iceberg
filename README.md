# CDC using Kafka
This is a setup to run an end-to-end CDC(Change Data Capture) pipeline from a postgres source Database to iceberg S3 sink.

## How to launch
```
AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN docker-compose up -d
```

## Components
### Source database
- PostgreSQL 16

### Kafka 
- Based on Kafka image provided by Bitnami. 
- Uses KRaft

### Kafka Connect

#### Source Connector
- Based on Debezium.
- After verifying that the Kafka Connect Container is up, start the source connector using the following command:

```
./create-debezium-pg-connector.sh
```

#### Sink Connector
- Requires AWS Connectivity. 
- Use temp credentials to interact with Glue and S3 clients.

##### Command (Assuming valid AWS Credentials env vars)
```
./create-iceberg-sink-connector.sh $S3_BUCKET $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY $AWS_SESSION_TOKEN
```

### Spark


## AWS Connectivity

If the temp credentials expire we need to stop the sink connector and bounce the container again with updated credentials env vars and then start the sink connector again.

```
AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN docker-compose up -d
```

This will only restart the connect container leaving rest intact.

