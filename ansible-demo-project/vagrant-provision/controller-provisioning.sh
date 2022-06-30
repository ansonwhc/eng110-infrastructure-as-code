#!/bin/bash

# update & upgrade
sudo apt-get update -y
sudo apt-get upgrade -y

# install dependencies
sudo apt-get install sshpass -y  # for connecting to guests via ssh

# install python3
sudo apt-get install python3 -y
sudo apt-get install python3-pip -y

# install ansible
# Ref: 
# - https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html (accessed 29/06/2022)
# - https://docs.ansible.com/ansible/latest/reference_appendices/python_3_support.html (accessed 29/06/2022)
pip3 install ansible
sudo echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
sudo echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
source ~/.profile
sudo echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile

# create /etc/ansible
sudo mkdir -p /etc/ansible
sudo touch /etc/ansible/hosts
sudo touch /etc/ansible/ansible.cfg

# add hosts
sudo bash -c 'cat <<EOF >>/etc/ansible/hosts
[web]
web_server1 ansible_host=192.168.33.10 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant
[db]
db_server1 ansible_host=192.168.33.11 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant
EOF'

# disable nodes pw check
sudo bash -c 'cat <<EOF >>/etc/ansible/ansible.cfg
[defaults]
host_key_checking = False
EOF'