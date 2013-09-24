This tutorial guides you through the process of creating cloud servers on Rackspace Public Cloud, installing Apache Ambari on one of the instances and using it to install a Hadoop cluster on rest of the instances.

1. Create Servers for the Hadoop Cluster:

From an  Ubuntu station: 

export OS_USERNAME=username
export OS_PASSWORD=apikey
export OS_TENANT_NAME=username
export OS_AUTH_SYSTEM=rackspace
export OS_AUTH_URL=https://identity.api.rackspacecloud.com/v2.0/
export OS_REGION_NAME=DFW
export OS_NO_CACHE=1

bash <(curl -s https://raw.github.com/sacharya/hadoop-101/master/ambari-hadoop/create-servers.sh)

When prompted:
image_id is any CentOS 6.X image id
flavor is any flavor
cluster size is size of Hadoop cluster plus one for Ambari Management node.

At the end of the run, the script will create two files:
etc_hosts.txt
hosts.txt

2. Prepare the servers:
SSH into the first server named cluster-name-Ambari. We will use it as an ambari server.

Update its /etc/hosts with host addresses from etc_hosts.txt.

Also, create a hosts.txt file with the hostnames for the cluster (except the ambari server) one per line.

# cat hosts.txt 
hadoop2
hadoop3
hadoop4
hadoop5

Now run the following script, which will ssh into all the servers and set them up.
bash <(curl -s https://raw.github.com/sacharya/hadoop-101/master/ambari-hadoop/prepare-cluster.sh)

Note: This step prompts for root password for each one of your servers.

3. Install Ambari:
bash <(curl -s https://raw.github.com/sacharya/hadoop-101/master/ambari-hadoop/install-ambari-server.sh)

4. Install Hadoop:
Login to Ambari
ambari-server:8080
admin/admin

Hosts:
cat hosts.txt

# SSH Private Key
cat ~/.ssh/id_rsa

Complete the installation using rest of the wizard.

5. Validate Hadoop:
ssh root@hadoop1

curl https://raw.github.com/sacharya/hadoop-101/master/ambari-hadoop/wordcount.sh | bash

su hdfs - -c "hadoop fs -ls /"
#su - hdfs
#hadoop jar /usr/lib/hadoop/hadoop-examples.jar pi 10 1000000
