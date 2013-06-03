1. Create Servers - one for ambari server plus the size of the hadoop cluster.
Login to an Ubuntu 12.04 Server, which will act as your workstation.

bash <(curl -s https://raw.github.com/sacharya/random-scripts/master/ambari-hadoop/create-servers.sh)

2. Install Ambari and Prepare the cluster.
Ssh to ambari server and update its /etc/hosts will all the other host addresses.

Create a hosts.txt file and list all the hostnames for the cluster one per line.

bash <(curl -s https://raw.github.com/sacharya/random-scripts/master/ambari-hadoop/prepare-cluster.sh)

bash <(curl -s https://raw.github.com/sacharya/random-scripts/master/ambari-hadoop/install-ambari-server.sh)

3. Install hadoop and validate
Login to Ambari
ambari-server:8080
admin/admin

Hosts:
cat hosts.txt

# SSH Private Key
cat ~/.ssh/id_rsa

su - hdfs
/usr/lib/hadoop/examples-*.jar pi 10 1000000
