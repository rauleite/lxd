#!/bin/bash


## Faz updates no host (local)?
host_updates="false"

## User ##
user="rleite"
user_dir="/home/$user"       # Nao alterar
old_username="ubuntu"        # Padrao, manter
old_group="ubuntu"           # Padrao, manter

## Container ##
ct_name="web1"
 
## Vm distro ##
vm_distro="ubuntu:17.04"
 
if [ $EUID == "0" ];
then
    echo "Não rode o script como root"
    exit 1
fi

if [ $host_updates == "true" ];
then
    ## Update base host ##
    sudo $_apt update
    sudo $_apt -y upgrade
    ## Install LXD on base os ##
    sudo $_apt -y install lxd
fi

# lxc profile create lb
# echo "Atualizando profile"
# cat profile.yaml | lxc profile edit lb

# $_lxd init --auto
 
## Create new networking bridge ##
# $_lxc network create ${br_net} ipv6.address=none ipv4.address=${if_net_sub} ipv4.nat=true
# $_lxc init images:${vm_distro} ${ct_name} -c security.privileged=$sec_privileged --verbose -p lb
lxc launch $vm_distro web1  --verbose
 
## Create vm ##
 
## Config vm networking ##
$_lxc network attach ${br_net} ${ct_name} ${if_net}
$_lxc config device set ${ct_name} ${if_net} ipv4.address ${if_net_ip}
 
## Start vm ##
$_lxc start ${ct_name}


## Make sure vm boot after host reboots ##
$_lxc config set ${ct_name} boot.autostart true
 


## Install updates in Ubuntu VM ##
$_lxc exec ${ct_name} -- $_apt -y install -f
$_lxc exec ${ct_name} -- $_apt -y update
$_lxc exec ${ct_name} -- $_apt -y upgrade
$_lxc exec ${ct_name} -- $_apt -y install nginx
$_lxc exec ${ct_name} -- $_apt -y install net-tools
$_lxc exec ${ct_name} -- $_apt -y install nano
 
## Configs and Install package (optional) ##

$_lxc exec ${ct_name} -- userdel -r $old_username
# $_lxc exec ${ct_name} -- groupdel $old_group
$_lxc exec ${ct_name} -- adduser $user --disabled-password --gecos ""
$_lxc exec ${ct_name} -- export user && sh -c 'echo $user"  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers'
$_lxc exec ${ct_name} -- mkdir $user_dir/.ssh
$_lxc exec ${ct_name} -- chmod 700 $user_dir/.ssh 
$_lxc exec ${ct_name} -- touch $user_dir/.ssh/authorized_keys
$_lxc exec ${ct_name} -- chmod 600 $user_dir/.ssh/authorized_keys

$_lxc exec ${ct_name} -- touch $user_dir/.ssh/authorized_keys
$_lxc exec ${ct_name} -- chmod 600 $user_dir/.ssh/authorized_keys

$_lxc list 
# $_lxc exec ${ct_name} -- /bin/bash
# $_lxc exec ${ct_name} -- sudo --login --user $user
