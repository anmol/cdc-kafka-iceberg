ARG DEBEZIUM_VERSION=2.7
FROM quay.io/debezium/connect-base:${DEBEZIUM_VERSION}
# FROM debezium/connect:${DEBEZIUM_VERSION}

ENV DEBEZIUM_VERSION="2.7.1.Final" \
    MAVEN_REPO_CENTRAL="" \
    MAVEN_REPOS_ADDITIONAL="" \
    POSTGRES_MD5=bf11bd82133150d7a79ddd549ff44fb8

RUN docker-maven-download debezium postgres "$DEBEZIUM_VERSION" "$POSTGRES_MD5"

ARG ICEBERG_CONNECTOR_VERSION=0.6.19

# ENV KAFKA_CONNECT_JDBC_DIR=$KAFKA_CONNECT_PLUGINS_DIR/kafka-connect-jdbc
ENV KAFKA_CONNECT_IS_DIR=$KAFKA_CONNECT_PLUGINS_DIR/kafka-connect-iceberg

# ARG KAFKA_JDBC_VERSION=5.3.2

RUN cd /kafka/libs && \
curl -sO https://repo1.maven.org/maven2/org/apache/commons/commons-configuration2/2.11.0/commons-configuration2-2.11.0.jar && \
curl -sO https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-auth/3.3.6/hadoop-auth-3.3.6.jar

# Copy the connector plugin into the Kafka Connect image
COPY target/tabular-iceberg-kafka-connect-${ICEBERG_CONNECTOR_VERSION}/lib $KAFKA_CONNECT_IS_DIR/

# Deploy Kafka Connect JDBC
# RUN mkdir $KAFKA_CONNECT_JDBC_DIR && cd $KAFKA_CONNECT_JDBC_DIR &&\
# 	curl -sO https://packages.confluent.io/maven/io/confluent/kafka-connect-jdbc/$KAFKA_JDBC_VERSION/kafka-connect-jdbc-$KAFKA_JDBC_VERSION.jar
