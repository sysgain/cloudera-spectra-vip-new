#/bin/sh
DataLakedir=$1
MasterNode=$2
InputFile=$3
EndPoint=$4
#Creating the Datalake Dirtectory
hadoop fs -mkdir $EndPoint/$DataLakedir
#Creating Cloudera user on hdfs cluster
sudo -u hdfs hdfs dfs -mkdir /user/cloudera
sudo -u hdfs hdfs dfs -chown cloudera:cloudera /user/cloudera
sudo -u hdfs hdfs dfs -chmod 777 /user/admin
wget -O /home/cloudera/wordcount.jar https://aztdrepo.blob.core.windows.net/clouderadirector/wordcount.jar
spark-submit --master yarn --deploy-mode client --executor-memory 1g --jars /home/cloudera/wordcount.jar --conf spark.driver.userClasspathFirst=true --conf spark.executor.extraClassPath=/home/cloudera/wordcount.jar --class com.SparkWordCount.SparkWordCount /home/cloudera/wordcount.jar hdfs://$MasterNode:8020/user/admin/$InputFile 0 $EndPoint/$DataLakedir/WordCount