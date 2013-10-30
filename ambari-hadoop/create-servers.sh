#!/bin/bash

set -x


# Install the Client
if [[ $EUID -ne 0 ]]; then
	sudo apt-get update
	sudo apt-get install python-dev python-pip python-virtualenv
else
	apt-get update
	apt-get install python-dev python-pip python-virtualenv    
fi

virtualenv ~/.env
source ~/.env/bin/activate
pip install pbr
pip install python-novaclient
pip install rackspace-novaclient

# Read AUTH Credentials
: ${OS_USERNAME:?"Need to set OS_USERNAME non-empty"}
: ${OS_PASSWORD:?"Need to set OS_PASSWORD non-empty"}
: ${OS_TENANT_NAME:?"Need to set OS_TENANT_NAME non-empty"}
: ${OS_AUTH_SYSTEM:?"Need to set OS_AUTH_SYSTEM non-empty"}
: ${OS_AUTH_URL:?"Need to set OS_AUTH_URL non-empty"}
: ${OS_REGION_NAME:?"Need to set OS_REGION_NAME non-empty"}
: ${OS_NO_CACHE:?"Need to set OS_NO_CACHE non-empty"}

# Write credentials to a file 
cat > ~/novarc <<EOF
OS_USERNAME=$OS_USERNAME
OS_TENANT_NAME=$OS_TENANT_NAME
OS_AUTH_SYSTEM=$OS_AUTH_SYSTEM
OS_PASSWORD=$OS_PASSWORD
OS_AUTH_URL=$OS_AUTH_URL
OS_REGION_NAME=$OS_REGION_NAME
OS_NO_CACHE=$OS_NO_CACHE
export OS_USERNAME OS_TENANT_NAME OS_AUTH_SYSTEM OS_PASSWORD OS_AUTH_URL OS_REGION_NAME OS_NO_CACHE
EOF

source ~/novarc

env

# Read Cluster details
nova image-list
read -p "Image ID: " IMAGE_ID
nova flavor-list
read -p "Flavor ID: " FLAVOR_ID
read -p "Cluster Name: " CLUSTER_NAME
read -p "Cluster Size. Please enter your hadoop cluster size plus an extra server for Management server: " CLUSTER_SIZE

# Create instances  for the cluster
ssh-keygen -t rsa

HOMEDIR=$(getent passwd $(whoami) | cut -d: -f6)

# Usage: boot flavod_id image_id server_name
# Creates server, saves the name and password in server_passwords.txt
boot() { 
	echo "Creating instance $3"
	password=`nova boot --flavor $1 --image $2 --file /root/.ssh/authorized_keys=${HOMEDIR}/.ssh/id_rsa.pub $3 | grep 'adminPass' | awk '{print $4}'`
	echo $3 root $password >> 'server_passwords.txt'
}

boot $FLAVOR_ID $IMAGE_ID $CLUSTER_NAME-Ambari
CLUSTER_SIZE=`expr $CLUSTER_SIZE - 1`
for i in $(eval echo "{1..$CLUSTER_SIZE}")
do    
	boot $FLAVOR_ID $IMAGE_ID $CLUSTER_NAME$i
done

is_not_active() {
	status=`nova show $1 | grep 'status' | awk '{print $4}'`
	if [ "$status" != "ACTIVE" ] && [ "$status" != "ERROR" ]; then
		echo "$1 in $status"
		return 0
	else
		return 1
	fi	
}

# Wait for all the instances to go ACTIVE or ERROR
while true
do
	READY=1
	for i in $(eval echo "{1..$CLUSTER_SIZE}")
	do  
		if is_not_active $CLUSTER_NAME$i; then
			READY=0
		fi
	done
	if is_not_active $CLUSTER_NAME-Ambari; then
		READY=0
	fi 

	echo "READY is $READY"
	if [ "$READY" -eq "1" ]; then
		break
	fi
	sleep 5
done

for i in $(eval echo "{1..$CLUSTER_SIZE}")
do
	echo $CLUSTER_NAME$i >> 'hosts.txt'
done
cat hosts.txt

record_ip(){
	private_ip=`nova show $1 | grep 'private network' | awk '{print $5}'`
	public_ip=`nova show $1 | grep 'accessIPv4' | awk '{print $4}'`
	echo $private_ip $1 >> 'etc_hosts.txt'
	echo $public_ip $1 >> 'etc_hosts.txt'
}

record_ip $CLUSTER_NAME-Ambari
for i in $(eval echo "{1..$CLUSTER_SIZE}"); do record_ip $CLUSTER_NAME$i; done

cat etc_hosts.txt

echo "CLUSTER is READY"
