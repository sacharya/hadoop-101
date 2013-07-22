#!/bin/bash

set -x

if [[ $EUID -ne 0 ]]; then
       echo "This script must be run as root"
          exit 1
      fi

      apt-get update
      apt-get install -y --force-yes debconf-utils pwgen

      IP=`ifconfig eth0 | grep inet | head -n1 | cut -d":" -f2 | cut -d" " -f1`

#CHEF_URL=${CHEF_URL:-http://$(hostname -f):4000}
CHEF_URL=${CHEF_URL:-http://$IP:4000}
AMQP_PASSWORD=${AMQP_PASSWORD:-$(pwgen -1)}
WEBUI_PASSWORD=${WEBUI_PASSWORD:-$(pwgen -1)}

echo "deb http://apt.opscode.com/ `lsb_release -cs`-0.10 main"| sudo tee /etc/apt/sources.list.d/opscode.list
echo "deb http://apt.opscode.com/ precise-0.10 main" | sudo tee /etc/apt/sources.list.d/opscode.list
mkdir -p /etc/apt/trusted.gpg.d
gpg --keyserver keys.gnupg.net --recv-keys 83EF826A
gpg --export packages@opscode.com|sudo tee /etc/apt/trusted.gpg.d/opscode-keyring.gpg >/dev/null

cat <<EOF | debconf-set-selections
chef chef/chef_server_url string ${CHEF_URL}
chef-solr chef-solr/amqp_password password ${AMQP_PASSWORD}
chef-server-webui chef-server-webui/admin_password password ${WEBUI_PASSWORD}
EOF

apt-get update
apt-get install -y --force-yes opscode-keyring
apt-get upgrade -y --force-yes
apt-get install -y --force-yes chef chef-server

SUDO_USER=root
HOMEDIR=$(getent passwd ${SUDO_USER} | cut -d: -f6)

mkdir -p ${HOMEDIR}/.chef
cp /etc/chef/validation.pem /etc/chef/webui.pem ${HOMEDIR}/.chef
chown -R ${SUDO_USER}: ${HOMEDIR}/.chef

cat <<EOF | knife configure -i
${HOMEDIR}/.chef/knife.rb
${CHEF_URL}
chefadmin
chef-webui
${HOMEDIR}/.chef/webui.pem
chef-validator
${HOMEDIR}/.chef/validation.pem

EOF

echo "Chef server installation complete."
