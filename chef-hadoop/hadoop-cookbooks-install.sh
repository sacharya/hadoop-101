#!/bin/bash

set -x

if [[ $EUID -ne 0 ]]; then
       echo "This script must be run as root"
          exit 1
      fi

      HDP_COOKBOOKS=https://github.com/sacharya/hdp-cookbooks.git
      OS_KNIFE_PLUGIN=https://github.com/sacharya/knife-alamo.git

# Make sure the Openstack Credentials are set.
: ${OS_USERNAME:?"Need to set OS_USERNAME non-empty"}
: ${OS_PASSWORD:?"Need to set OS_PASSWORD non-empty"}
: ${OS_TENANT_NAME:?"Need to set OS_TENANT_NAME non-empty"}
: ${NOVA_REGION_NAME:?"Need to set NOVA_REGION_NAME non-empty"}
: ${OS_AUTH_URL:?"Need to set OS_AUTH_URL non-empty"}

SUDO_USER=root
HOMEDIR=$(getent passwd ${SUDO_USER} | cut -d: -f6)

# Grab the cookbooks and upload them to chef-server
apt-get -y install git-core
git clone ${HDP_COOKBOOKS}

cat >> /root/.chef/knife.rb <<EOF
cookbook_path ["${HOMEDIR}/hdp-cookbooks/cookbooks"]
EOF

knife cookbook upload -a

# Grab knife-alamo and install it
git clone ${OS_KNIFE_PLUGIN}
apt-get install -y ruby ruby-dev libopenssl-ruby rdoc ri irb build-essential wget ssl-cert curl
curl -O http://production.cf.rubygems.org/rubygems/rubygems-1.8.10.tgz
tar zxf rubygems-1.8.10.tgz
cd ${HOMEDIR}/rubygems-1.8.10 
ruby setup.rb --no-format-executable
gem install chef --no-ri --no-rdoc

cd ${HOMEDIR}/knife-alamo
gem build knife-alamo.gemspec
gem install knife-alamo-*.gem

cat >> /root/.chef/knife.rb <<EOF
knife[:alamo][:openstack_user] = "$OS_USERNAME"
knife[:alamo][:openstack_pass] = "$OS_PASSWORD"
knife[:alamo][:openstack_tenant] = "$OS_TENANT_NAME"
knife[:alamo][:openstack_region] = "$NOVA_REGION_NAME"
knife[:alamo][:controller_ip] = "$OS_AUTH_URL"

knife[:alamo][:instance_login] = "root"
knife[:alamo][:validation_pem]  = "${HOMEDIR}/.chef/validation.pem"
EOF

for role in ${HOMEDIR}/hdp-cookbooks/roles/*.json; do knife role from file  $role; done

knife environment from file ${HOMEDIR}/hdp-cookbooks/environments/example.json

echo "HDP Cookbooks uploaded and Knife-alamo installed and configured. You may now proceed..."

