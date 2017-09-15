#!/bin/bash
# lxc stop ha && lxc publish ha

ct_name="$1"
img_alias="$2"

if [ $EUID == "0" ];
then
    echo "Não rode o script como root, pecado"
    exit 1
fi

if [[ -z $ct_name || -z $img_alias || "$1" == "--help" || "$1" == "-h" ]];
then
    echo "# Parametros obrigatorios:"
    echo "1- container-name     Ex. web1, web2, proxy, outside, test"
    echo "2- img-alias          Ex. web1/posconfigs"
    exit 1
fi


echo "esta indo..."
lxc stop $ct_name &>/dev/null && lxc publish $ct_name --verbose --alias $img_alias