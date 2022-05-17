#!/bin/bash
declare -A osInfo;
osInfo[/etc/debian_version]="apt"
osInfo[/etc/alpine-release]="apk"
osInfo[/etc/centos-release]="yum"
osInfo[/etc/fedora-release]="dnf"

for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        package_manager=${osInfo[$f]}
    fi
done

sudo $package_manager install python3
sudo echo "export python=python3" >> ~/.bashrc
sudo echo "export python=python3" >> ~/.profile
source ~/.bashrc
source ~/.profile