#!/bin/bash

cmd_install='sudo apt-get install -y'

install_netdata () {
    $cmd_install zlib1g-dev
    $cmd_install uuid-dev
    $cmd_install libmnl-dev
    $cmd_install gcc
    $cmd_install make
    $cmd_install git
    $cmd_install autoconf
    $cmd_install autoconf-archive
    $cmd_install autogen
    $cmd_install automake
    $cmd_install pkg-config
    # lxc exec ${ct_name} -- sh -c 'curl -Ss "https://raw.githubusercontent.com/firehol/netdata-demo-site/master/install-required-packages.sh" >/tmp/kickstart.sh && bash /tmp/kickstart.sh -i netdata -y'
    git clone https://github.com/firehol/netdata.git --depth=1 netdata && cd netdata && sudo ./netdata-installer.sh && cd ../ && sudo rm -r netdata
    # lxc exec ${ct_name} -- sh -c 'curl -Ss "https://raw.githubusercontent.com/firehol/netdata-demo-site/master/install-required-packages.sh" >/tmp/kickstart.sh && bash /tmp/kickstart.sh -i netdata-all -y'

}

update_upgrade () {
    echo "Espedando archive.ubuntu.com (Se demorar 1 minuto pode dar Ctrl^C, e comentar a linha de update do script)"
    until ping -c1 archive.ubuntu.com &>/dev/null; do :; done
    until ping -c1 security.ubuntu.com &>/dev/null; do :; done
    sudo apt-get update
    sudo apt-get install -y language-pack-pt
    sudo apt-get -y upgrade
}

## Update base host ##

## Install LXD on base os ##
update_upgrade
$cmd_install lxc
$cmd_install lxd
$cmd_install zfsutils-linux

install_netdata

# sudo cp ./ufw-enable.sh /usr/bin
# sudo cp ./ufw-start.sh /usr/bin


# VER COMO SERA 
# lxd init --auto

# Pool
# lxc storage create poolzfs zfs
