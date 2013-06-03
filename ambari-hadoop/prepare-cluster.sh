#!/bin/bash

set -x

# Generate SSH keys
ssh-keygen -t rsa
cd ~/.ssh
cat id_rsa.pub >> authorized_keys

cd ~
# Distribute SSH keys
for host in `cat hosts.txt`; do
    cat ~/.ssh/id_rsa.pub | ssh root@$host "mkdir -p ~/.ssh; cat >> ~/.ssh/authorized_keys"
    cat ~/.ssh/id_rsa | ssh root@$host "cat > ~/.ssh/id_rsa; chmod 400 ~/.ssh/id_rsa"
    cat ~/.ssh/id_rsa.pub | ssh root@$host "cat > ~/.ssh/id_rsa.pub"
done

# Distribute hosts file
for host in `cat hosts.txt`; do
    scp /etc/hosts root@$host:/etc/hosts
done

# Prepare other basic things
for host in `cat hosts.txt`; do
    ssh root@$host "sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config"
    ssh root@$host "chkconfig iptables off"
    ssh root@$host "/etc/init.d/iptables stop"
    echo "enabled=0" | ssh root@$host "cat > /etc/yum/pluginconf.d/refresh-packagekit.conf"
done
