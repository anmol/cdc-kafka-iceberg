# LocalStack

A docker-compose variant of localstack so we can control the localstack version. Alternatively, you can install localstack cli 

## Set up LocalStack

1. Start localstack container and awscli containers.
   ```shell
   docker compose up
   ```
   
2. Create streams on localstack
   ```shell
   aws --profile localstack kinesis create-stream --stream-name stream-products --shard-count 1
   aws --profile localstack kinesis create-stream --stream-name stream-orders --shard-count 1
   aws --profile localstack kinesis create-stream --stream-name stream-receipts --shard-count 1
   aws --profile localstack kinesis create-stream --stream-name stream-fat --shard-count 1
   ```

3. Stream records


4. Delete streams 
   ```shell
   aws -profile localstack kinesis delete-stream --stream-name stream-products
   aws -profile localstack kinesis delete-stream --stream-name stream-orders
   aws -profile localstack kinesis delete-stream --stream-name stream-receipts
   aws -profile localstack kinesis delete-stream --stream-name stream-fat
   ```
