![](/images/Screenshot%202022-05-17%20113620.png)

![](/images/ansible.png)

# Exercise
1. Create 3 VMs with Vagrant
    - app & db & controller
    - config stored in [Vagrantfile](Vagrantfile)
        - Within we can run our [provision.sh](provision.sh)
    - `vagrant up`

        ![](/images/Screenshot%202022-05-17%20125945.png)

2. Create Ansible controller with 2 agent nodes - web & db
    - Set up Ansible controller `vagrant ssh controller`
    
    step |setup command | function
    --- | --- | ---
    1 | `sudo apt-get install software-properties-common` | install common software
    2 | `sudo apt-add-repository ppa:ansible/ansible` | adding repository
    3 | `sudo apt-get update -y` | update
    4 | `sudo apt-get install ansible` | install ansible
    5 - optional | . | upgrade python to python3, required later
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

3. Set up Ansible controller with required dependencies

4. test ansible --version

5. python --version 2.7 -> ideally 3 or above

6. what is .yaml/.yml 

7. Adhoc commands with Ansible
    - Allow us to give commands to multiple VMs at the same time
    - `sudo ansible all -a "uname -a"`  # get uname -a from all machines under ansible controller
    - `sudo ansible all -a "sudo apt-get update -y"`
    - to transfer files between nodes, http://www.freekb.net/Article?id=3009#:~:text=The%20ansible%20ad%2Dhoc%20command,directory%20on%20the%20managed%20node.
        - `sudo ansible web --module-name copy --args "src=/etc/ansible/test.txt dest=."`
        - `sudo ansible web --module-name copy --args "src=web-dependencies.sh dest=."`

8. testing connection between controller and agent nodes

9. ssh - vagrant - between VMs

10. Ansible folder/file structure

11. Ansible hosts/inventroy

12. Ansible playbooks - playbook.yml -> same code to be applied to all servers automatically
    - `sudo nano nginx.yml`
        - remember to use two spaces
        - sudo ansible-playbook playbook.yml

13. Why learn yml
    - used with Ansible
    - Cloud Formation AWS
    - Docker compose
    - Kubernetes
