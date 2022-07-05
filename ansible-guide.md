# Ansible
- Quick Example [here](/ansible-demo-project/)
- What is Ansible [here](#what-is-ansible)
- Architecture [here](#architecture)
- Ansible setup [here](#ansible-setup)
- Ansible Vault Setup with AWS [here](#ansible-vault-setup-with-aws)


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

## File separation
It is a good practice to separate the files to store information instead of keeping all information within one file.  

We can define variables in a variety of places, such as in inventory, in playbooks, in reusable files, in roles, and at the command line. Ansible loads every possible variable it finds, then chooses the variable to apply based on [variable precedence rules](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#ansible-variable-precedence).  

More info [here](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#where-to-set-variables)  

- Example

    **Original:**

    _/etc/ansible/hosts_

        [aws_agent]
        ec2-instance ansible_host=8.8.8.8 ansible_user=ubuntu ansible_ssh_private_key_file=/path/to/ssh_key

    **Second iteration:**

    _host_vars location_

        ~/path_to_playbooks
        ├── ping-playbook.yml
        └── host_vars
            └── ec2-instance.yml

    _/etc/ansible/hosts_

        [aws_agent]
        ec2-instance

    _~/path_to_playbooks/ping-playbook.yml_

        ---
        - name: Ping play
          hosts: aws_agent
          tasks:
            - name: ping task
              ping:

    _~/path_to_playbooks/host_vars/ec2-instance.yml_ 

        ansible_host: 8.8.8.8
        ansible_user: ubuntu
        ansible_ssh_private_key_file: /path/to/ssh_key

- There are many other usages, e.g., 
    `- include_tasks: <task-1.yml>`
    `- import_tasks: <task-1.yml>`
    `- import_playbook: <playbook-1.yml>`
        
## Roles
Roles let you automatically load related vars, files, tasks, handlers, and other Ansible artifacts based on a known file structure. After you group your content in roles, you can easily reuse them and share them with other users.

[Ansible Galaxy](https://galaxy.ansible.com/docs/) is a free site for finding, downloading, rating, and reviewing all kinds of community-developed Ansible roles and can be a great way to get a jumpstart on your automation projects.

To use written roles, simply run: `ansible-galaxy install <role>`  

To create roles, simply run: `ansible-galaxy init <role>`. The default structure would be created.

<!-- Quick example [here]() -->  

More info on downloading, and using roles [here](https://galaxy.ansible.com/docs/using/installing.html#roles)  

## Asynchronous actions and polling
Asynchronous actions are ansible tasks that run in the background which can be checked or followed up later.  

They are are useful when we don't want Ansible to hold the connection to the remote node open until the action is completed, e.g. monitoring tasks.  

- To set the timeout-duration of the ansible background task   
    `async: <async-action-timeout-seconds>`  

- To specify the freqency of automatic status-checking by Ansible  
    `polling: <status-checking-every-n-seconds>`  

    - When `polling > 0`, Ansible will still block the next task in your playbook, waiting until the current async task either completes, fails or times out. However, the task will only time out if it exceeds the timeout limit you set with the `async` parameter.

    - When `polling = 0`, tasks in the playbook will run concurrently. Ansible starts the task and immediately moves on to the next task without waiting for a result. Each async task runs until it either completes, fails or times out (runs longer than its async value). The playbook run ends without checking back on async tasks.

        - If you need a synchronization point with an async task, you can register it to obtain its job ID and use the async_status module to observe it in a later task. For example:

                - name: Run an async task
                apt:
                    name: docker-io
                    state: present
                async: 1000
                poll: 0
                register: apt_sleeper

                - name: Check on an async task
                async_status:
                    jid: "{{ apt_sleeper.ansible_job_id }}"
                register: job_result
                until: job_result.finished
                retries: 100
                delay: 10

More info [here](https://docs.ansible.com/ansible/latest/user_guide/playbooks_async.html)

## Controlling playbook execution
- Strategy
    - Ansible strategy specifies the way that tasks are carried out in a playbook
    1. Linear strategy (default)
        - Up to the fork limit of hosts will execute each task at the same time and then the next series of hosts until the batch is done, before going on to the next task
    2. Free strategy
        - Ansible will not wait for other hosts to finish the current task before queuing more tasks for other hosts
        - A host that is slow or stuck on a specific task won’t hold up the rest of the hosts and tasks
    3. Debug strategy
        - Task execution is ‘linear’ but controlled by an interactive debug session

    - For example

            - hosts: all
            strategy: free
            tasks:
            # ...

    - Change default strategy: can be changed in the `ansible.cfg` file, for example:

            [defaults]
            strategy = free

<!-- (Ansible side) -->
- Forks
    - Ansible works by spinning off forks of itself and talking to many remote systems independently (default 5)
    - The number can be specified in the `ansible.cfg` file, for example:

            [defaults]
            forks = 30

- Keywords
    <!-- (Remote agent side) -->
    - `serials`
        - A number, a percentage, or a list of numbers of hosts/machines you want to manage at a time, similar to specifying a batch size
        - Ansible completes the play on the specified number or percentage of hosts before starting the next batch of hosts

    - `throttle`
        - Limits the number of workers for a particular task
        - To have an effect, your throttle setting must be lower than your forks or serial setting if you are using them together

    - `order`
        - Control how Ansible selects the next host in a group
        - Possible values ([here](https://docs.ansible.com/ansible/latest/user_guide/playbooks_strategies.html#ordering-execution-based-on-inventory)):
            1. inventroy
            2. reverse_iventory
            3. sorted
            4. reverse_sorted
            5. shuffle 

    - `run_once`
        - Run a task on a single host
        - Ansible executes this task on the first host in the current batch and applies all results and facts to all the hosts in the same batch
        -  To run the task on a specific host, instead of the first host in the batch, delegate the task by `delegate_to: <host>`

More info [here](https://docs.ansible.com/ansible/latest/user_guide/playbooks_strategies.html)

## Error handling
[here](https://docs.ansible.com/ansible/latest/user_guide/playbooks_error_handling.html)

## Playbooks filters
[here](https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters.html)