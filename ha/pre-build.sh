#!/bin/bash

Validar antes de rodar
exit 1


## Faz updates no host (local)?
host_updates="false"

if [ $host_updates == "true" ];
then
    ## Update base host ##
    sudo apt-get update
    sudo apt-get -y upgrade

    ## Install LXD on base os ##
    sudo apt-get -y install lxd
    sudo pat-get -y install zfsutils-linux
fi

lxd init --auto

# Pool
lxc storage create poolzfs zfs
