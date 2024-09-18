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


## Important Points

### Source Connector and Kafka Producer partition assignment Strategy

Following table depicts the available strategies

| Strategy                 | Description   |
| ------------------------ | ------------- |
| Default partitioner      | The key hash is used to map messages to partitions. Null key messages are sent to a partition in a round-robin fashion.  |
| Round-robin partitioner  | Messages are sent to partitions in a round-robin fashion.  |
| Uniform sticky partitioner | Messages are sent to a sticky partition (until the batch.size is met or linger.ms time is up) to reduce latency. |
| Custom partitioner | his approach implements the Partitioner interface to override the partition method with some custom logic that defines the key-to-partition routing strategy. |


Generally we expect all tables to have a primary key.
Debezium Connector pushes a table's Primary Key(PK) or Unique Key(could be composite) as the Kafka message key to the broker. Since we use Default Partitioner the hash of the keys would be used to map the partitions. In case of absence of a PK or Unique Key Constraint the message key is sent as null and round-robin partitioner is used in that case.

However, Debezium still gives a way to manually add keys to the connector configurations should the table has missing constraints which otherwise is there semantically. Ideally the tables' constraints should be updated to avoid any unexpected behaviour.


