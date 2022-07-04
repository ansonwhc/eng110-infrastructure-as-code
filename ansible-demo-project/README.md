# Ansible Sample E-Commerce Application
This folder will contain info on using Ansible to setup a [sample e-commerce application](https://github.com/kodekloudhub/learning-app-ecommerce).

It is a sample e-commerce application built for learning purposes. We will be deploying on Ubuntu 20.04 systems in a multi-node architecture.

## Content
1. [VMs setup](#vms-setup)
2. [Multi-node architecture](#multi-node-architecture)
3. [Ansible playbooks](#ansible-playbooks)
4. [mysql user password](#mysql-user-password)

## VMs setup
We will be using Vagrant ([Vagrantfile](/ansible-demo-project/Vagrantfile)) for creating
1. Ansible controller
2. Web Node (Front-end)
3. Database Node (Back-end)

(each with their own provisioning files [here](/ansible-demo-project/vagrant-provision/))

## Multi-node architecture
We will create a Ansible controller to manage two nodes (front-end, back-end). 

- The web node contains a web page is written in PHP (index.php)
- The database node contains a Mariadb and is accessed by MySQL
- The Web node can access the MySQL-database using the created account

![](/images/ansible-demo-project-arch.png)

## Ansible playbooks
This directory contains 4 playbooks stored [here](/ansible-demo-project/ansible-playbooks/). The plays and order are in reference to the original setup [here](https://github.com/kodekloudhub/learning-app-ecommerce).

## mysql user password
Reference:
- [ansible-vault](https://docs.ansible.com/ansible/latest/cli/ansible-vault.html)
- [managing-vault-password](https://docs.ansible.com/ansible/latest/user_guide/vault.html#managing-vault-passwords)

Steps:  
1. Become root user  
    [vagrant@controller:~#] `sudo su`

2. Go to default ansible dir  
    [vagrant@controller:/#] `cd /etc/ansible/`

3. Recurssively create dirs of group_vars for all hosts  
    [vagrant@controller:/#] `mkdir -p group_vars/all/`

4. Create and open a file in an editor that will be encrypted with the provided vault secret when closed  
    [vagrant@controller:/#] `ansible-vault create mysql_pass.yml` 
        
5. Will be prompted to input a vault password  
    [vagrant@controller:/#] enter password: `<mysql_vault_password>`    
    This will open mysql_pass.yml with vim by default  

6. Input the password variable to be encrypted and stored  
    
            > mysql_password: ecompassword

7. We can save the vault password in a seperate file    
    [vagrant@controller:/#] `echo "<mysql_vault_password>" /etc/ansible/mysq_vault_password`  

8. Use `mysql_vault_password` file to access the vault, e.g.  
    [vagrant@controller:/#] `ansible-vault edit mysql_pass.yml --vault-pass-file /etc/ansible/mysql_vault_password`
