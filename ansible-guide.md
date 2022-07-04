# Ansible
- What is Ansible [here](#what-is-ansible)
- Architecture [here](#architecture)
- Ansible setup [here](#ansible-setup)
- Ansible Vault Setup with AWS [here](#ansible-vault-setup-with-aws)
- Quick Example [here](/ansible-demo-project/)

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

- Ubuntu apt-get install
    - `sudo apt-get install software-properties-common -y`  
    - `sudo apt-add-repository ppa:ansible/ansible`  
    - `sudo apt-get update -y`  
    - `sudo apt-get install ansible -y`  
    - `ansible --version`  
- pip3 install
    - `sudo apt-get install python3 -y`
    - `sudo apt-get install python3-pip -y`
    - `pip3 install ansible`

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
- `ansible web -a "systemctl status nginx"` - Check status of nginx  

### Playbook structure for installing packages
```
# Ansible playbook contains plays, written in a YAML file
$ sudo touch first-playbook.yml

# YAML YML file starts with three dashes ---
---

# The name of the current play
- name: Install packages on a ubuntu machine

# Location to install the packages
  hosts: web

# Whether to see logs or not
  gather_facts: yes

# Whether to become root user on the guest machine
  become: true

# The tasks of the current play
  tasks:

  # The task name
  - name: Ensure packages being present
    
    # Package manager of a ubuntu machine
    apt:
      
      # Name of the packages that we are concern about
      name: "{{ item }}"  # items that we reference in the "loop" below

      # What state these packages should be in
      state: present
    
    # Looping the task with the variables below (reference by using "item")
    loop:
      - nginx
      - firewalld

# Command to run Playbook
$ ansible-playbook first-playbook.yml
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
