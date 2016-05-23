# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$bootstrap=<<SCRIPT

#Common tools
sudo apt-get update
sudo apt-get -y install wget unzip jq

#Docker Engine
sudo apt-get -y install apt-transport-https ca-certificates
sudo apt-get -y install linux-image-extra-$(uname -r)
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo sh -c "echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list"
sudo apt-get update
sudo apt-get -y purge lxc-docker
sudo apt-cache policy docker-engine
sudo apt-get -y install docker-engine=1.11.1-0~trusty
sudo gpasswd -a vagrant docker
sudo service docker restart

#Docker Machine
sudo sh -c "curl -L https://github.com/docker/machine/releases/download/v0.7.0/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && chmod +x /usr/local/bin/docker-machine"

#Azure CLI
echo "alias azure='docker run -it --rm -v \\\$HOME/.azure:/root/.azure -v \\\$PWD:/data -w /data microsoft/azure-cli:latest azure'" >> $HOME/.bashrc

#Terraform
echo "alias terraform='docker run -it --rm -v \\\$PWD:/data -w /data hashicorp/terraform:0.6.14'" >> $HOME/.bashrc

SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Every Vagrant virtual environment requires a box to build off of.

  config.vm.box = "ubuntu/trusty64"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.

  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provider "virtualbox" do |vb|
     vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  config.vm.provision :shell, inline: $bootstrap, privileged: false

end

