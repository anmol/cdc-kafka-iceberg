ARG DEBEZIUM_VERSION=2.7
FROM debezium/connect:${DEBEZIUM_VERSION}

ARG ICEBERG_CONNECTOR_VERSION=0.6.15

ENV KAFKA_CONNECT_IS_DIR=$KAFKA_CONNECT_PLUGINS_DIR/kafka-connect-iceberg

USER kafka

# Copy the connector plugin into the Kafka Connect image
COPY target/iceberg-kafka-connect-runtime-${ICEBERG_CONNECTOR_VERSION}/lib $KAFKA_CONNECT_IS_DIR/
