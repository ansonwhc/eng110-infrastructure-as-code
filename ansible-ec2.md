under controller VM
`sudo apt-get install python3`
`alias python=python3`
`sudo apt-get install python3-pip`
`sudo apt-add-repository --yes --update ppa:ansible/ansible`
`sudo apt-get install ansible`

latest botocore: https://github.com/boto/botocore
`git clone https://github.com/boto/botocore.git`
`cd botocore`
`pip install -r requirements.txt`
`pip install -e .`
`pip install botocore`

latest aws: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
`curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"`
`unzip awscliv2.zip`
`sudo ./aws/install`
`aws --version`

latest boto3: https://github.com/boto/boto3
`git clone https://github.com/boto/boto3.git`
`cd boto3`
`python -m pip install -r requirements.txt`
`python -m pip install -e .`

boto: https://github.com/boto/boto/
`git clone git://github.com/boto/boto.git`
`cd boto`
`python setup.py install`

OR:
`sudo pip3 install boto boto3 botocore==1.26.1`

OR:
`pip3 install botocore==1.26.0`
`sudo python3 -m pip install awscli==1.24.0 botocore==1.26.0`
`pip3 install boto boto3==1.23.0 botocore==1.26.0`

- set up Ansible vault - aws access & secret keys
- provide key
    1. option - transfer/cp file.pem to ansible controller
    2. option - generate ssh key on the controller to use as a ssh key pair between controller & agent nodes
- check to see if the keys have been secured with ansible-vault


`cd /etc/ansible`
`sudo mkdir group_vars`
`cd group_vars/`
`sudo mkdir all`
`cd all`

`sudo ansible-vault create pass.yml`
`sudo ansible-vault edit pass.yml`
`ii`   # insert mode
`ec2_access_key: `
`ec2_secret_key: `
`[esc] :wq! [enter]`

Set up .pem key within .ssh folder
TODO: automate copying this file
`cd ~/.ssh`
`ssh-keygen -t rsa -b 4096 -C "your_email@example.com"`
`sudo chmod 400 eng119.pub`
`sudo nano eng119.pem`   # previous key
`sudo chmod 400 eng119.pem`

Pass the .pem to hosts for signing in
`cd /etc/ansible`
>[local]
>localhost ansible_python_interpreter=/usr/local/bin/python3
>[aws]
>ec2-instance ansible_host=aws-public-ip ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/eng119.pem


Run ansible playbooks to set up the app on aws
`sudo ansible-playbook <playbook>.yml --ask-vault-pass`
Current notebooks stored: [here](/ec2-ansible-playbooks)
- To run ec2-controller-playbook.yml:
- `sudo ansible-playbook ec2-controller-playbook.yml --ask-vault-pass --tags create_ec2`
