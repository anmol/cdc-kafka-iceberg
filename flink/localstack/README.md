# LocalStack

A docker-compose variant of localstack so we can control the localstack version. Alternatively, you can install localstack cli 

## Set up LocalStack

1. Start localstack container and awscli containers.
   ```shell
   docker compose up
   ```
   
2. Create streams on localstack
   ```shell
   aws --profile localstack kinesis create-stream --stream-name product-stream --shard-count 1
   aws --profile localstack kinesis create-stream --stream-name order-stream --shard-count 1
   aws --profile localstack kinesis create-stream --stream-name receipt-stream --shard-count 1
   aws --profile localstack kinesis create-stream --stream-name enriched-orders-stream --shard-count 1
   ```

3. Stream records


4. Delete streams 
   ```shell
   aws -profile localstack kinesis delete-stream --stream-name product-stream
   aws -profile localstack kinesis delete-stream --stream-name order-stream
   aws -profile localstack kinesis delete-stream --stream-name receipt-stream
   aws -profile localstack kinesis delete-stream --stream-name enriched-orders-stream
   ```
