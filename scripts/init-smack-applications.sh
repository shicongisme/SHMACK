#!/bin/bash

####################
### Kafka Topics ###
####################
dcos kafka topic create sensor-reading --partitions 5 --replication 2
dcos kafka topic create sensor-reading-accelerometer --partitions 5 --replication 2
dcos kafka topic create data-analytics --partitions 5 --replication 2
dcos kafka topic create dump --partitions 5 --replication 2



#######################################
### Hackzurich Sensor-ingestion app ###
#######################################
dcos marathon app add /home/bewe/shmack/hackzurich-sensordataanalysis/sensor-ingestion/sensor-ingestion-options.json



##################################
### KafkaToCassandra spark job ###
##################################
#dcos spark run --submit-args="--properties-file=service-configs/spark-hackzurich.KafkaToCassandra.conf --conf spark.cores.max=2 --driver-memory 8G --conf spark.driver.cores=2 --executor-memory 4G --conf spark.executor.cores=2 --class com.zuehlke.hackzurich.KafkaToCassandra https://s3-us-west-1.amazonaws.com/benedikt.wedenik.kafka.cassandra/KafkaToCassandra-all.jar"




######################################
### KafkaToAccelerometer spark job ###
######################################
dcos spark run --submit-args="--properties-file=service-configs/spark-hackzurich.KafkaToAccelerometer.conf --conf spark.cores.max=2 --driver-memory 8G --conf spark.driver.cores=2 --executor-memory 4G --conf spark.executor.cores=2 --class com.zuehlke.hackzurich.KafkaToAccelerometer https://s3-us-west-1.amazonaws.com/benedikt.wedenik.kafka.cassandra/KafkaToAccelerometer-all.jar"



#####################################
### Spark DataAnalytics spark job ###
#####################################
#dcos spark run --submit-args="--properties-file=service-configs/spark-hackzurich.DataAnalytics.conf --conf spark.cores.max=1 --driver-memory 2G --conf spark.driver.cores=1 --executor-memory 1G --conf spark.executor.cores=1 --class com.zuehlke.hackzurich.DataAnalytics https://s3-us-west-1.amazonaws.com/benedikt.wedenik.kafka.cassandra/spark-data-analytics-all.jar"
dcos spark run --submit-args="--properties-file=service-configs/spark-hackzurich.DataAnalytics.conf --conf spark.cores.max=2 --driver-memory 8G --conf spark.driver.cores=2 --executor-memory 4G --conf spark.executor.cores=2 --class com.zuehlke.hackzurich.DataAnalytics https://s3-us-west-1.amazonaws.com/benedikt.wedenik.kafka.cassandra/spark-data-analytics-all.jar"



#########################################################
### Akka app to display data from Spark DataAnalytics ###
#########################################################
dcos marathon app add /home/bewe/shmack/hackzurich-sensordataanalysis/akka-data-analytics/akka-data-analytics-options.json

