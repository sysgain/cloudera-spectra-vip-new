#!/bin/sh
DirUserName=$1
Dirpassword=$2
HostName=$3
DirUrl="$HostName:7189"
Confpath='/home/cloudera/azure.simple.expanded.conf'
#cloudera-director bootstrap-remote $Confpath --lp.remote.username=$1 --lp.remote.password=$2 --lp.remote.hostAndPort=$DirUrl
cloudera-director bootstrap-remote $Confpath --lp.remote.username=$DirUserName --lp.remote.password=$Dirpassword --lp.remote.hostAndPort=$DirUrl
