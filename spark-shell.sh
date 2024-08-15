spark-shell --jars /Users/anmol.gautam/Software/iceberg-spark-runtime-3.4_2.12-1.6.0.jar \
  --conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions \
  --conf spark.sql.catalog.spark_catalog=org.apache.iceberg.spark.SparkSessionCatalog \
  --conf spark.sql.catalog.spark_catalog.type=hive \
  --conf spark.sql.catalog.local=org.apache.iceberg.spark.SparkCatalog \
  --conf spark.sql.catalog.local.type=hadoop \
  --conf spark.sql.catalog.local.warehouse=$PWD/data/kafka/out/iceberg_bkp/warehouse \
  --conf spark.sql.defaultCatalog=local