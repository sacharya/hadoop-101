#!/bin/bash

set -x

# Install the Client
sudo apt-get update
sudo apt-get install python-setuptools
sudo easy_install pip
sudo pip install rackspace-novaclient

# Read AUTH Credentials
: ${OS_USERNAME:?"Need to set OS_USERNAME non-empty"}
: ${OS_PASSWORD:?"Need to set OS_PASSWORD non-empty"}
: ${OS_TENANT_NAME:?"Need to set OS_TENANT_NAME non-empty"}
: ${OS_AUTH_SYSTEM:?"Need to set OS_AUTH_SYSTEM non-empty"}
: ${OS_AUTH_URL:?"Need to set OS_AUTH_URL non-empty"}
: ${OS_REGION_NAME:?"Need to set OS_REGION_NAME non-empty"}
: ${OS_NO_CACHE:?"Need to set OS_NO_CACHE non-empty"}

# Read Cluster details
nova image-list
read -p "Image ID: " IMAGE_ID
nova flavor-list
read -p "Flavor ID: " FLAVOR_ID
read -p "Cluster Name: " CLUSTER_NAME
read -p "Cluster Size. Please enter your hadoop cluster size plus an extra server for Management srever: " CLUSTER_SIZE

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

# Create instances  for the cluster
ssh-keygen -t rsa

nova boot --flavor $FLAVOR_ID --image $IMAGE_ID --file /root/.ssh/authorized_keys=/root/.ssh/id_rsa.pub $CLUSTER_NAME-Ambari
HADOOP_SIZE=`expr $CLUSTER_SIZE - 1`
for i in $(eval echo "{1..$HADOOP_SIZE}")
do
    echo "Creating instance $i"    
    nova boot --flavor $FLAVOR_ID --image $IMAGE_ID --file /root/.ssh/authorized_keys=/root/.ssh/id_rsa.pub $CLUSTER_NAME$i
done

# Wait for all the instances to go ACTIVE or ERROR
while true
do
    READY=1;
    for i in $(eval echo "{1..$HADOOP_SIZE}")
    do  
        status=`nova show $CLUSTER_NAME$i | grep 'status' | awk '{print $4}'` 
        if [ "$status" != "ACTIVE" ] && [ "$status" != "ERROR" ]; then
            echo "$CLUSTER_NAME$i in $status"
            READY=0;
        fi
    done
    ambari_status=`nova show $CLUSTER_NAME-Ambari | grep 'status' | awk '{print $4}'`
    if [ "$ambari_status" != "ACTIVE" ] && [ "$ambari_status" != "ERROR" ]; then
        echo "$CLUSTER_NAME-Ambari in $ambari_status"
        READY=0;
    fi 
    echo "READY is $READY"
    if [ "$READY" -eq "1" ]; then
        break
    fi
    sleep 5
done

echo $CLUSTER_NAME-Ambari >> 'hosts.txt'
for i in $(eval echo "{1..$HADOOP_SIZE}")
do
    echo $CLUSTER_NAME$i >> 'hosts.txt'
done
echo "CLUSTER is READY"
