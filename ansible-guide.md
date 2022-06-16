# Ansible
- What is Ansible [here](#what-is-ansible)
- Architecture [here](#architecture)
- Ansible setup [here](#ansible-setup)
- Ansible Vault Setup with AWS [here](#ansible-vault-setup-with-aws)
- Quick Example [here](#quick-example)

## What is Ansible?
Ansible is an open-source software provisioning, configuration management, and application-deployment tool enabling infrastructure as code.

It runs on many Unix-like systems, and can configure both Unix-like systems as well as Microsoft Windows.

We can use Ansible automation to install software, provision infrastructure, improve security, patch systems, and share automation across the entire organization.

Ansible works by connecting to what you want automated and pushing programs that execute instructions that would have been done manually.

### How is Ansible different from simply running a provisioning bash shell?
Bash (or another scripting language) describes actions. Do this thing. Now do this other thing.

Ansible describes the desired state. This file should exist here, owned by this user, with these permissions. This package should be installed. This line in this config file should appear like this.

## Architecture
- Design goals
    - Minimal in nature
        - Management systems should not impose additional dependencies on the environment.
    - Consistent
        - With Ansible one should be able to create consistent environments.
    - Secure
        - Ansible does not deploy agents to nodes. Only OpenSSH and Python are required on the managed nodes.
    - Reliable
        - When carefully written, an Ansible playbook can be idempotent, to prevent unexpected side-effects on the managed systems. It is possible to write playbooks that are not idempotent.
- Ansible vault
    - Sensitive data can be stored in encrypted files using 
    - e.g.: AWS access ID & AWS Secret access key
- Agentless architecture
    ![](/images/ansible.png)
    - It does not install software on the nodes that it manages. This removes a potential point of failure and security vulnerability and simultaneously saves system resources.
    - It uses SSH protocol to connect the servers. Ansible requires Python to make the use of modules on client machines.
- Dependencies
    - Ansible requires Python to be installed on all managing machines, including pip package manager.
- Control node
    - The control node (master host) is intended to manage (orchestrate) target machines (nodes termed as "inventory")
    - Nodes are managed by the controlling node over SSH
- Inventory configuration
    - Location of target nodes is specified through inventory configuration lists located at /etc/ansible/hosts (on Linux)
    - The configuration file lists either the IP address or hostname of each node that is accessible by Ansible. 
    - Nodes can be assigned to groups.
- Playbooks
    - Playbooks are YAML files that store lists of tasks for repeated executions on managed nodes.
    - Each Playbook maps (associates) a group of hosts to a set of roles. Each role is represented by calls to Ansible tasks
    - Same code to be applied to all servers automatically.
- Roles
    - Roles let us automatically load related vars, files, tasks, handlers, and other Ansible artifacts based on a known file structure.
    - After we group our content in roles, we can easily reuse them and share them with other users.

## Ansible Setup
### Install Ansible

- `sudo apt-get install software-properties-common -y`  
- `sudo apt-add-repository ppa:ansible/ansible`  
- `sudo apt-get update -y`  
- `sudo apt-get install ansible -y`  
- `ansible --version`  

### Check connection
- Getting into the managed node
    - `ssh vagrant@<IP>` (with password)
- Simply checking connectivity
    - `ansible web -m ping` 

### Connecting to nodes via hosts
- `cd /etc/ansible/`
- `sudo apt-get install tree -y` - not required for Ansible, helps visualise file structure
- `sudo nano hosts`

```
[<group>]
<IP> ansible_connection=ssh ansible_ssh_user=<username, e.g. vagrant> ansible_ssh_pass=<username, e.g. vagrant>
```

### Adhoc commands in Ansible
- `ansible all -a "uname -a"` - Names OS of all hosts  
- `ansible web -a "free"` - Space available on server  
- `ansible web -a "systemctl nginx"` - Check status of nginx  

### Setting up a playbook for nginx
```
# creating a playbook to configure Nginx web server in web machine
# YAML YML file starts with three dashes ---
---
# Where do we want to install nginx
- hosts: web
# Do we want to see logs - gather facts
  gather_facts: yes
# What permissions do we need to run this playbook
  become: true
# used for sudo/admin
# what is the name of the package
  tasks:
  - name: install Nginx
    apt: pkg=nginx state=present
# state=inactive
# What should be the status of nginx once the playbook is finish
# Command to run Playbook - ansible-playbook file.yml
```

### Playbook for setting up app
```
- hosts: web
  gather_facts: yes
  become: true
  tasks:
  - name: node app set up
    shell: |
      cd <path/to/app.js>
      sudo apt-get install software-properties-common -y
      curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
      sudo apt-get install -y nodejs
      sudo apt-get update -y
      npm install
      npm start
```

## Ansible Vault Setup with AWS
- `cd /etc/ansible/`
- Create folder structure for ansible vault
    - `mkdir -p group_vars/all/`
- Set up ansible vault - AWS access & secret keys
    - `sudo ansible-vault create pass.yml`
    - `(sudo ansible-vault edit pass.yml) (to edit)`

            ec2_access_key: xxxx
            ec2_secret_key: xxxx

- Copy SSH key from local to controller
    - From `hosts`

            [aws]
            ec2-instance ansible_host=<aws-public-ip> ansible_user=<user_name> ansible_ssh_private_key_file=<pass/to/ssh_key e.g. ~/.ssh/eng119.pem>

- To use the credentials stored in the vault
    - `ansible-playbook <playbook> --ask-vault-pass`



## Quick Example
- For playbook examples: 
    - [ec2-ansible-playbooks](/ec2-ansible-playbooks/)
    - [vagrant-ansible-playbooks](/vagrant-ansible-playbooks/)

- Application Architecture
    - We want to deploy the [sg_application_from_aws](/sg_application_from_aws/)
    - It requires nginx, nodejs, mongodb, and setting an environment variable
    - More details [here](/sg_application_from_aws/README.md)

    ![](/images/ansible-app-db.png)

1. Create 3 VMs with Vagrant
    - app & db & controller
    - config stored in [Vagrantfile](Vagrantfile)
        - (Optional) Within we can run our [controller_provision.sh](/vagrant-executables/controller_provision.sh) to set up ansible
    - `vagrant up`

        ![](/images/Screenshot%202022-05-17%20125945.png)

2. Manually create Ansible controller with 2 agent nodes - web & db
    - Set up Ansible controller `vagrant ssh controller`
    - (If not yet done) Install python --version 2.7 -> ideally 3 or above
    - Set up Ansible controller with required dependencies
    - test `ansible --version`
    
    step |setup command | function
    --- | --- | ---
    1 | `sudo apt-get install software-properties-common` | install common software
    2 | `sudo apt-add-repository ppa:ansible/ansible` | adding repository
    3 | `sudo apt-get update -y` | update
    4 | `sudo apt-get install ansible` | install ansible
    5 - optional | `alias python=python3` | set alias python to python3, required later
    6 | `sudo apt-get install tree` | prettier output of dirs

    - check connection with db (within controller VM)
    `ssh vagrant@192.168.33.11`  
    password: `vagrant`  
    `sudo apt-get update -y`  
    - this sign-in process allows for the key to be saved to the "ansible known hosts"

    - check connection with web (within controller VM)
    `ssh vagrant@192.168.33.10`  
    password: `vagrant`  
    `sudo apt-get update -y`  
   - this sign-in process allows for the key to be saved to the "ansible known hosts"

    - we can ssh into the db and web from controller because we have ansible installed and being the controller of these two VMs

    - under `/etc/ansible/` we should see ansible.cfg, hosts, and roles
    - `cd /etc/ansible/`
    - `sudo nano hosts`
        - indi IP -> upgrouped hosts
        - group IPs -> [webservers], e.g. ASG
        - add web & db IPs to grouped hosts
            ![](/images/Screenshot%202022-05-17%20135355.png)

    - `sudo ansible web -m ping` -> access denied, because we haven't set up any keys to sign in to the web machine yet
        - `ping` is just connecting to an IP, can do bbc.com
    - add these next to the IPs
        - ansible_connection=ssh
        - ansible_ssh_user=vagrant
        - ansible_ssh_pass=vagrant

    - `sudo ansible all -m ping` -> check all machines connection
    ![](/images//Screenshot%202022-05-17%20140050.png)

3. Adhoc commands with Ansible
    - Allow us to give commands to multiple VMs at the same time
    - `sudo ansible all -a "uname -a"`  # get uname -a from all machines under ansible controller
    - `sudo ansible all -a "sudo apt-get update -y"`
    - to transfer files between nodes, http://www.freekb.net/Article?id=3009#:~:text=The%20ansible%20ad%2Dhoc%20command,directory%20on%20the%20managed%20node.
        - `sudo ansible web --module-name copy --args "src=/etc/ansible/test.txt dest=."`

4. Setup an web application and a database
    - Copy playbooks in [vagrant-ansible-playbooks](/vagrant-ansible-playbooks/) to the Ansible controller VM
    - From the controller, run the [setup.yml](/vagrant-ansible-playbooks/setup.yml)
        - within the file, it imports all other ansible playbooks including:
            - [db.yml](/vagrant-ansible-playbooks/db.yml)
            - [nginx.yml](/vagrant-ansible-playbooks/nginx.yml)
            - [nodejs.yml](/vagrant-ansible-playbooks/nodejs.yml)
            - [start-app.yml](/vagrant-ansible-playbooks/start-app.yml)

5. Access the web application from the web VM IP `192.168.33.10`
    - Application should be running
    - `192.168.33.10:3000` - homepage
    - `192.168.33.10:3000/fibonacci/3` - fibonacci function page (the third number in the fibonacci sequence)
    - `192.168.33.10:3000/posts` - database

