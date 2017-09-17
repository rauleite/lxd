#!/bin/bash

build_bin="./build.sh"

## Container ##
ct_name="$1"
ct_type="$2"
 
## Vm images ##
img="$3"
alias="$4"

network="$5"

## Facilidade ##
lxc_exec="lxc exec ${ct_name} --"
lxc_install="${lxc_exec} apt-get install -y"


if [[ -z $ct_name || -z $ct_type || -z $img || -z $alias || -z $network || "$1" == "--help" || "$1" == "-h" ]];
then
    echo 'Images:'
    lxc image list
    echo 'Containers:'    
    lxc list
    echo "# Todos Parametros sao obrigatorios:"
    echo "1- Nome que quer dar ao container     Ex. web1 | web2 | proxy | test"
    echo "2- Perfil de configuracoes do cont.   Um entre: nginx | proxy | test"
    echo "3- Img base                           Ex. ubuntu/zesty/amd64 | proxy/posbuild"
    echo "4- Alias para a imagem                Ex. ubuntu"
    echo "5- Network - existente ou nao         Ex. lxcbr0"
    exit 1
fi

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
    echo "Espedando archive.ubuntu.com (Se demorar 1 minuto pode dar Ctrl^C, e comentar a linha de update do script)"
    until ping -c1 archive.ubuntu.com &>/dev/null; do :; done
    until ping -c1 security.ubuntu.com &>/dev/null; do :; done
    $lxc_exec apt-get update
    $lxc_exec apt-get -y upgrade
    $lxc_install nano
    $lxc_install net-tools
    $lxc_install curl
}

# Baixa se nao existir a imagem 2&>1 
lxc image show $alias &>/dev/null || lxc image copy images:$img local: --alias $alias
# lxc launch $alias $ct_name

echo "- launching"
lxc launch $alias $ct_name
echo "- creanting network"
lxc network create $network 2&> /dev/null
lxc network set $network ipv6.address none
echo "- attaching network"
lxc network attach $network $ct_name

sleep 5

if [ "$ct_type" = "proxy" ]
then
    echo "level 2 - Van Chase"
    add_redis_repo
    update_essenciais
    install_haproxy
    install_redis_server
elif [ "$ct_type" = "nginx" ]
then
    echo "level 3 - The Hotel"
    add_redis_repo
    update_essenciais
    install_nginx
    install_redis_server
elif [ "$ct_type" = "test" ]
then
    echo "level 0 - Isolated"
    update_essenciais
else
    echo "Tem que digitar um tipo valido"
    exit 1
fi

# exec_configs
lxc list $ct_name
$lxc_exec bash

# exec_configs () {
#     # lxc exec ${ct_name} -- userdel -r $old_username
#     # Nao ha necessidade pra adicionar usuario
#     # lxc exec ${ct_name} -- adduser $user --disabled-password --gecos ""
#     # lxc exec ${ct_name} -- export user && sh -c 'echo $user"  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers'
#     # lxc exec ${ct_name} -- mkdir $user_dir/.ssh
#     # lxc exec ${ct_name} -- chmod 700 $user_dir/.ssh
#     # lxc exec ${ct_name} -- touch $user_dir/.ssh/authorized_keys
#     # lxc exec ${ct_name} -- chmod 600 $user_dir/.ssh/authorized_keys
# }


# if [ $EUID == "0" ];
# then
#     echo "Não rode o script como root, pecado"
#     exit 1
# fi

# ct_root_dir=/var/lib/lxd/containers/$ct_name/rootfs/root

# if [ "$ct_type" = "outside" ]
# then
#     echo "level 1 - Reality"
#     lxc_launch="lxc launch $alias $ct_name"
#     $lxc_launch --config security.nesting=true

#     echo "Copiar para $ct_root_dir"
#     sudo cp $build_bin $ct_root_dir

#     update_essenciais

#     # $lxc_install lxd
#     # $lxc_install zfsutils-linux
#     # $lxc_install firehol
        

#     # $lxc_exec /bin/bash


## User ##
# user="rleite"
# user_dir="/home/$user"       # Nao alterar
# old_username="ubuntu"        # Padrao, manter



# sudo apt-get install -y lxd
# $lxc_install zfsutils-linux
# $lxc_install firehol