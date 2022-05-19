#!/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y

# install ansible and dependencies
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update -y
sudo apt-get install ansible

sudo rm /etc/ansible/hosts
sudo cp hosts /etc/ansible/hosts

sudo ansible-playbook web-playbook.yml