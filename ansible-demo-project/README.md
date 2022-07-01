# Ansible Sample E-Commerce Application
This folder will contain info on using Ansible to setup a [sample e-commerce application](https://github.com/kodekloudhub/learning-app-ecommerce)

## VMs setup
We will be using Vagrant for 

## mysql user password
Reference:
- [ansible-vault](https://docs.ansible.com/ansible/latest/cli/ansible-vault.html)
- [managing-vault-password](https://docs.ansible.com/ansible/latest/user_guide/vault.html#managing-vault-passwords)

        # become root user
        sudo su

        # go to default ansible dir
        cd /etc/ansible/

        # recurssively create dirs of group_vars for all hosts
        mkdir -p group_vars/all/

        # create and open a file in an editor that will be encrypted with the provided vault secret when closed
        ansible-vault create mysql_pass.yml

        # This will be the vault password
        $ enter password: <mysql_vault_password> 

            # This will open mysql_pass.yml with vim by default

            # input the password variable to be encrypted and stored
            > mysql_password: ecompassword

        # we can save the vault password in a seperate file
        echo "<mysq_vault_password>" /etc/ansible/mysq_vault_password

        # Use `mysq_vault_password` file to access the vault, e.g.
        ansible-vault edit mysql_pass.yml --vault-pass-file /etc/ansible/mysql_vault_password
