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
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.181.140.158  suda-hadoop1
166.78.48.17    suda-hadoop1
2001:4800:7811:0513:c3d8:ce16:ff04:358c suda-hadoop1

10.181.133.54 suda-hadoop2
166.78.48.219 suda-hadoop2

10.181.129.27 suda-hadoop3
166.78.48.81 suda-hadoop3

10.181.146.31 suda-hadoop4
166.78.48.127 suda-hadoop4

10.181.134.206 suda-hadoop5
166.78.48.166 suda-hadoop5


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
/usr/lib/hadoop/examples-*.jar pi 10 1000000
