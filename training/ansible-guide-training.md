## Quick Example
- For playbook examples: 
    - [ec2-ansible-playbooks](/ec2-ansible-playbooks/)
    - [vagrant-ansible-playbooks](/vagrant-ansible-playbooks/)

- Application Architecture
    - We want to deploy the [sg_application_from_aws](/sg_application_from_aws/)
    - It requires nginx, nodejs, mongodb, and setting an environment variable
    - More details [here](/sg_application_from_aws/READMe.md)

    <img src="https://user-images.githubusercontent.com/94448528/174245634-8438efc0-00fd-473a-a93f-939ee9445b3c.png" height="550">

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