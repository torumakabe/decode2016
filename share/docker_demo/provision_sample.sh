#!/bin/bash

# Create Swarm Master Node on Azure
export AZURE_SUBSCRIPTION_ID='your_subscription_id'
export AZURE_IMAGE='canonical:UbuntuServer:14.04.4-LTS:latest'
export AZURE_SIZE='Standard_D1'
export AZURE_LOCATION='japanwest'

docker-machine create -d azure --swarm --swarm-master --swarm-discovery 'token://your_swarm_token' --swarm-strategy 'binpack' swarm-manager

docker run -it --rm -v $HOME/.azure:/root/.azure -v $PWD:/data -w /data microsoft/azure-cli:latest azure network nsg rule create -g docker-machine -a swarm-manager-firewall -n nginx -p tcp -u 80-88 -c Allow -y 1000

#Create Swarm Agent Node on OpenStack (Conoha)
export OS_USERNAME='your_username'
export OS_TENANT_ID='your_tenant_id'
export OS_TENANT_NAME='your_tenant_name'
export OS_PASSWORD='your_password'
export OS_AUTH_URL='https://identity.tyo1.conoha.io/v2.0'

docker-machine create -d openstack --openstack-flavor-name g-1gb --openstack-image-name vmi-ubuntu-14.04-amd64 --openstack-sec-groups 'default,gncs-ipv4-all' --swarm --swarm-discovery 'token://your_swarm_token' swarm-conoha00
