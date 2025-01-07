FROM bitnami/spark:3.4.2
USER root
RUN install_packages curl
USER 1001
COPY ./spark2/libs/aws-glue-datacatalog-spark-client-3.4.0-SNAPSHOT.jar /opt/bitnami/spark/jars/
