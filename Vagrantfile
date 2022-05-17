# -*- mode: ruby -*-
# vi: set ft=ruby :



# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what



# MULTI SERVER/VMs environment
#
Vagrant.configure("2") do |config|



    # creating first VM called web
    config.vm.define "web" do |web|
    
        web.vm.box = "bento/ubuntu-18.04"
        # downloading ubuntu 18.04 image
        
        web.vm.hostname = 'web'
        # assigning host name to the VM
        
        web.vm.network :private_network, ip: "192.168.33.10"
        # assigning private IP

        web.vm.provision "shell", path: "web_provision.sh"

        web.vm.synced_folder "sg_application_from_aws", "/home/vagrant/sg_application_from_aws"
        
        # controller.vm.provision "ansible" do |ansible|
        #     ansible.playbook = "web-playbook.yml"
        # end

        # config.hostsupdater.aliases = ["development.web"]
        # creating a link called development.web so we can access web page with this link instread of an IP
    
    end
    
    # creating second VM called db
    config.vm.define "db" do |db|
    
        db.vm.box = "bento/ubuntu-18.04"
        
        db.vm.hostname = 'db'
        
        db.vm.network :private_network, ip: "192.168.33.11"

        db.vm.provision "shell", path: "db_provision.sh"
        
        # config.hostsupdater.aliases = ["development.db"]
    end
    
    
    
    # creating are Ansible controller
    config.vm.define "controller" do |controller|
    
        controller.vm.box = "bento/ubuntu-18.04"
        
        controller.vm.hostname = 'controller'
        
        controller.vm.network :private_network, ip: "192.168.33.12"

        controller.vm.synced_folder ".", ".", type: "rsync", 
        rsync__args: ["--include=web-playbook.yml"]
        
        controller.vm.synced_folder ".", ".", type: "rsync", 
        rsync__args: ["--include=web-dependencies.sh"]

        controller.vm.synced_folder ".", ".", type: "rsync", 
        rsync__args: ["--include=hosts"]

        controller.vm.provision "shell", path: "controller_provision.sh"

        # config.hostsupdater.aliases = ["development.controller"]
        
    end
    
    
    
end