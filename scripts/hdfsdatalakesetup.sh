#!/bin/sh
adminpassword=$1
datalakeDirName=$2
datalakeEndPoint=$3
clientId=$4
tenantId=$5
clientSecret=$6
MangerIP="10.3.0.5"
DirectorIP="10.3.0.4"
curl -u admin:admin 'http://'${MangerIP}':7180/api/v1/clusters/Director_Azure_Deployment/services' > /tmp/ClouderaServices
cat /tmp/ClouderaServices  | grep 'serviceUrl' | awk -F'/' '{print $6}' | tr -d '",' > /tmp/CServices
HDFS=`grep HDFS /tmp/CServices`
echo $HDFS
Name1="dfs.adls.oauth2.client.id"
Value1="${clientId}"
Name2="dfs.adls.oauth2.refresh.url"
Value2="https://login.windows.net/${tenantId}/oauth2/token"
Name3="dfs.adls.oauth2.credential"
Value3="${clientSecret}"
Name4="dfs.adls.oauth2.access.token.provider.type"
Value4="ClientCredential"
Name5="fs.adl.impl"
Value5="org.apache.hadoop.fs.adl.AdlFileSystem"
Name6="fs.AbstractFileSystem.adl.impl"
Value6="org.apache.hadoop.fs.adl.Adl"
Name7="dfs.adl.test.contract.enable"
Value7="true"
ClusterName="Director_Azure_Deployment"
curl -X PUT -H "content-Type:application/json" -u admin:admin -d '{ "items": [ { "name" : "core_site_safety_valve", "value" : "<property><name>'$Name1'</name><value>'$Value1'</value></property><property><name>'$Name2'</name><value>'$Value2'</value></property><property><name>'$Name3'</name><value>'$Value3'</value></property><property><name>'$Name4'</name><value>'$Value4'</value></property><property><name>'$Name5'</name><value>'$Value5'</value></property><property><name>'$Name6'</name><value>'$Value6'</value></property><property><name>'$Name7'</name><value>'$Value7'</value></property>" }]}' 'http://10.3.0.5:7180/api/v1/clusters/'${ClusterName}'/services/'${HDFS}'/config'
sleep 30
/bin/chmod 600 /home/cloudera/sshKeyForAzureVM
curl -u admin:admin 'http://'${MangerIP}':7180/api/v1/hosts' > /tmp/ClouderaHosts
MasterIP=`cat /tmp/ClouderaHosts | grep 'ipAddress' | sed -n 2p | awk -F':' '{print $2}' | sed 's/"//g' | sed 's/,//g' | sed 's/ //g'`
#cat /tmp/ClouderaHosts | grep 'ipAddress' | sed -n 2p | awk -F':' '{print $2}' | sed 's/"//g' | sed 's/,//g' > /tmp/mhost
echo "Cloudera Director Node private IPAddress: $DirectorIP" >> /home/cloudera/NodeDetails
echo "Cloudera Manager Node private IPAddress: $MangerIP" >> /home/cloudera/NodeDetails
echo "Cloudera Master Node private IPAddress: $MasterIP" >> /home/cloudera/NodeDetails
echo "Cloudera Hue Web UI URL: http://$MasterIP:8888" >> /home/cloudera/NodeDetails
echo "Cloudera Hue Web UI Username/Password: admin/admin" >> /home/cloudera/NodeDetails
echo "Your Datalake Directory for the testdrive: $datalakeDirName" >> /home/cloudera/NodeDetails
echo "Your Datalake Endpoint for the testdrive: $datalakeEndPoint" >> /home/cloudera/NodeDetails
echo "Your Output Data files on Datalake for the testdrive:  $datalakeEndPoint/$datalakeDirName/WordCount" >> /home/cloudera/NodeDetails
#curl -X POST -u admin:admin 'http://'${MangerIP}':7180/api/v1/clusters/'${ClusterName}'/services/'${HDFS}'/commands/restart'
#sleep 60
#curl -X POST -u admin:admin 'http://'${MangerIP}':7180/api/v1/clusters/'${ClusterName}'/commands/restart'
