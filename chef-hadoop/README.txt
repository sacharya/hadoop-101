1. Login to an Ubuntu 12.04 server as root, which we will use as a chef-server..

2. Install Chef Server
curl -L "https://raw.github.com/sacharya/hadoop-101/master/chef-hadoop/chef-server-install.sh" | bash

3. Install Hadoop Cookbooks and Knife plugin for OpenStack
export OS_USERNAME=admin
export OS_PASSWORD=admin
export OS_TENANT_NAME=admin
export NOVA_REGION_NAME=RegionOne
export OS_AUTH_URL=10.10.10.2

curl -L "https://raw.github.com/sacharya/hadoop-101/master/chef-hadoop/hadoop-cookbooks-install.sh" | bash

Once complete,

vi ~/.chef/knife.rb

# Login info of your bastion server.
knife[:alamo][:bastion] = "192.168.1.2"
knife[:alamo][:ssh_user] = "root"
knife[:alamo][:ssh_pass] = "password"
knife[:alamo][:key_name] = "mykey"

4. 4. 4. 4. 

