#!/bin/bash

set -x

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Install Ambari server
cd ~
wget http://public-repo-1.hortonworks.com/ambari/centos6/1.x/GA/ambari.repo
cp ambari.repo /etc/yum.repos.d/
yum install -y epel-release
yum repolist
yum install -y ambari-server

# Setup Ambari server
ambari-server setup -s

# Start Ambari server
ambari-server start

ps -ef | grep Ambari
