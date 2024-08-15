FROM bitnami/spark:3.4.2
USER root
RUN install_packages curl
USER 1001
RUN curl https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-3.4_2.12/1.6.0/iceberg-spark-runtime-3.4_2.12-1.6.0.jar  --output /opt/bitnami/spark/jars/iceberg-spark-runtime-3.4_2.12-1.6.0.jar 