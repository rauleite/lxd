#!/bin/bash

## User ##
user="rleite"
user_dir="/home/$user"       # Nao alterar
old_username="ubuntu"        # Padrao, manter

## Container ##
ct_name="$1"
ct_type="$2"
 
## Vm distro ##
distro="ubuntu/zesty/amd64"
alias="ubuntu"

## Facilidade ##
lxc_exec="lxc exec ${ct_name} --"
lxc_install="${lxc_exec} apt-get install -y"
lxc_launch="lxc launch $alias $ct_name"

if [ $EUID == "0" ];
then
    echo "Não rode o script como root, pecado"
    exit 1
fi

if [[ -z $ct_name || -z $ct_type || "$1" == "--help" || "$1" == "-h" ]];
then
    echo "# Lembre que pode alterar o nome do usuario neste script - $user"
    echo "# Parametros:"
    echo "container-name    | Obrigatorio |  (Ex. test, web1, web2, proxy, ouside)"
    echo "container-tipo    | Obrigatorio |  (Um entre: test, nginx, proxy, outside) - Instala essenciais"
    exit 1
fi

install_netdata () {
    $lxc_install zlib1g-dev
    $lxc_install uuid-dev
    $lxc_install libmnl-dev
    $lxc_install gcc
    $lxc_install make
    $lxc_install git
    $lxc_install autoconf
    $lxc_install autoconf-archive
    $lxc_install autogen
    $lxc_install automake
    $lxc_install pkg-config
    # lxc exec ${ct_name} -- sh -c 'curl -Ss "https://raw.githubusercontent.com/firehol/netdata-demo-site/master/install-required-packages.sh" >/tmp/kickstart.sh && bash /tmp/kickstart.sh -i netdata -y'
    $lxc_exec sh -c 'git clone https://github.com/firehol/netdata.git --depth=1 netdata && cd netdata && ./netdata-installer.sh -y && cd ../ && rm -r netdata'
    # lxc exec ${ct_name} -- sh -c 'curl -Ss "https://raw.githubusercontent.com/firehol/netdata-demo-site/master/install-required-packages.sh" >/tmp/kickstart.sh && bash /tmp/kickstart.sh -i netdata-all -y'

}

add_redis_repo () {
    $lxc_exec add-apt-repository ppa:chris-lea/redis-server
}

install_redis_server() {
    $lxc_install redis-server
}

install_nginx () {
    $lxc_install nginx    
}

install_haproxy () {
    $lxc_install haproxy
}

update_essenciais () {
    echo "Espera: archive.ubuntu.com (Demorar muito dar Ctrl^C)"
    until ping -c1 archive.ubuntu.com &>/dev/null; do :; done
    $lxc_exec apt-get update
    $lxc_exec apt-get -y upgrade
    $lxc_install nano
    $lxc_install nano
    $lxc_install net-tools
    $lxc_install curl
}

exec_configs () {
    lxc exec ${ct_name} -- userdel -r $old_username
    # Nao ha necessidade pra adicionar usuario
    # lxc exec ${ct_name} -- adduser $user --disabled-password --gecos ""
    # lxc exec ${ct_name} -- export user && sh -c 'echo $user"  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers'
    # lxc exec ${ct_name} -- mkdir $user_dir/.ssh
    # lxc exec ${ct_name} -- chmod 700 $user_dir/.ssh
    # lxc exec ${ct_name} -- touch $user_dir/.ssh/authorized_keys
    # lxc exec ${ct_name} -- chmod 600 $user_dir/.ssh/authorized_keys
}
# Baixa se nao existir a imagem 2&>1 
lxc image show $alias &>/dev/null || lxc image copy images:$distro local: --alias $alias
# lxc launch $alias $ct_name

if [ "$ct_type" = "outside" ]
then
    echo "level 1 - Reality"
    $lxc_launch -c security.nesting=true
    # lxc exec ${ct_name} -- apt-get -y install lxd
    # lxc exec ${ct_name} -- apt-get -y install zfsutils-linux
elif [ "$ct_type" = "proxy" ]
then
    echo "level 2 - Van Chase"
    $lxc_launch
    add_redis_repo
    update_essenciais
    install_netdata
    install_haproxy
    install_redis_server
elif [ "$ct_type" = "nginx" ]
then
    echo "level 3 - The Hotel"
    $lxc_launch
    add_redis_repo
    update_essenciais
    install_nginx
    install_redis_server
else
    echo "Tem que digitar um tipo valido"
    exit 1
fi

exec_configs
