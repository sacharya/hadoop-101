1. Create Servers for the Hadoop Cluster:
  - One server for ambari server
  - And the size of the hadoop cluster.
Eg. if you want a Hadoop Cluster with 5 nodes, create a total of 6 servers, where the extra one will be used for Ambari.

You can use the following command to create the servers from any Ubuntu station. 

bash <(curl -s https://raw.github.com/sacharya/random-scripts/master/ambari-hadoop/create-servers.sh)

2. Prepare the servers:
SSH into the first server that you just created. We will use it as an ambari server.

Update its /etc/hosts will all the other host addresses.
Eg. 
# cat /etc/hosts
private-ip1  suda-hadoop1
public-ip2    suda-hadoop1

private-ip2 suda-hadoop2
public-ip2 suda-hadoop2

private-ip3 suda-hadoop3
public-ip3 suda-hadoop3

private-ip4 suda-hadoop4
public-ip4 suda-hadoop4

private-ip5 suda-hadoop5
public-ip5 suda-hadoop5

Also, create a hosts.txt file and list all the hostnames for the cluster (except the ambari server) one per line.

# cat hosts.txt 
suda-hadoop2
suda-hadoop3
suda-hadoop4
suda-hadoop5

Now run the following script, which will ssh into all the servers and set them up.
bash <(curl -s https://raw.github.com/sacharya/random-scripts/master/ambari-hadoop/prepare-cluster.sh)

3. Install Ambari:
bash <(curl -s https://raw.github.com/sacharya/random-scripts/master/ambari-hadoop/install-ambari-server.sh)

4. Install Hadoop:
Login to Ambari
ambari-server:8080
admin/admin

Hosts:
cat hosts.txt

# SSH Private Key
cat ~/.ssh/id_rsa

5. Validate Hadoop:
From any of the Hadoop nodes,

su - hdfs
hadoop jar /usr/lib/hadoop/hadoop-examples.jar pi 10 1000000
