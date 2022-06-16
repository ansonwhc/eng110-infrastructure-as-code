#!/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y

# install python3.x
sudo apt-get install software-properties-common
sudo apt-get install python3
echo "alias python=python3" >> ~/.bashrc
source ~/.bashrc
echo "alias python=python3" >> ~/.bash_aliases
source ~/.bash_aliases

# install ansible
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update -y
sudo apt-get install ansible -y

# added [web] and [db] into hosts file
sudo rm /etc/ansible/hosts
sudo mv hosts /etc/ansible/hosts

# sudo ansible-playbook web-playbook.yml