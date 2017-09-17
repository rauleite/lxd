#!/bin/bash

# Comandos LVM
# https://debian-administration.org/article/410/A_simple_introduction_to_working_with_LVM

# Tutorial Xen
# https://help.ubuntu.com/community/XenProposed

#  Com Xen --------------------------------------

# apt-get install xen-hypervisor-amd64

# # Modify GRUB to default to booting Xen:
# sed -i 's/GRUB_DEFAULT=.*\+/GRUB_DEFAULT="Xen 4.1-amd64"/' /etc/default/grub
# update-grub
# # Set the default toolstack to xm (aka xend):
# sed -i 's/TOOLSTACK=.*\+/TOOLSTACK="xm"/' /etc/default/xen

# reboot

# apt-get install bridge-utils

# sudo service network-manager stop


# # ### /etc/network/interface ###
# # interfaces(5) file used by ifup(8) and ifdown(8)
# # auto lo
# # iface lo inet loopback

# # auto xenbr0
# # iface xenbr0 inet dhcp
# #     bridge_ports eth0

# # auto eth0
# # iface eth0 inet manual

# service networking restart

# sudo service network-manager start

# ---------------------------------------------------

drive_fisico='/dev/sda6'
grupo='outside'
nome='ubuntu'
tamanho='19.5G'

# Physics
pvcreate $drive_fisico
# Group
vgcreate $grupo $drive_fisico
vgscan
pvs
# Agrupa disco logica (mas so ha 1 mesmo) - nome do disco = ubuntu
lvcreate -L $tamanho -n $nome $grupo
lvdisplay $grupo

# mkdir /mnt/outside/
# Formata /dev/grupo/nome
# mkfs.ext4 /dev/outside/ubuntu /mnt/outside/
# Monta


# COM XEN -------------------------------------
# mount /dev/outside/ubuntus /mnt/outside/

# # /etc/xen/xend-config.sxp:
# (xend-unix-server yes)

# # /etc/init.d/xend restart
# /etc/init.d/xen restart

# # OPCAO de baixar manualmente

# wget http://jp.archive.ubuntu.com/ubuntu/dists/zesty/main/installer-amd64/current/images/netboot/xen/initrd.gz
# wget http://jp.archive.ubuntu.com/ubuntu/dists/zesty/main/installer-amd64/current/images/netboot/xen/vmlinuz


# sudo apt-get install virtinst

# virt-install \
# --name ubuntu \
# --ram 512 \
# --disk /dev/outside/ubuntu \
# --location http://jp.archive.ubuntu.com/ubuntu/dists/zesty/main/installer-amd64/ \
# --network bridge=xenbr0 \
# --debug 

# ------------------------------------------------

# ### Erroooo ###

# Add or edit the following line in the /etc/default/grub file:
# GRUB_CMDLINE_XEN_DEFAULT="dom0_mem=512M,max:512M"
# then run update-grub and reboot
# ----
# If you are using the XL toolstack this can be done by editing /etc/xen/xl.conf and setting autoballoon=0. This will prevent XL from ever automatically adjusting the amount of memory assigned to dom0.


# -----------------------------

mkdir /vserver/images

dd if=/dev/zero of=/vserver/images/vm_base.img bs=1024k count=1000
dd if=/dev/zero of=/vserver/images/vm_base-swap.img bs=1024k count=500

mkdir /mnt/vserver
debootstrap --arch arm64 zesty /mnt/vserver/ http://archive.ubuntu.com/ubuntu

####
# # /etc/network/interfaces -- configuration file for ifup(8), ifdown(8)
# # The loopback interface
# auto lo
# iface lo inet loopback

# # The first network card - this entry was created during the Debian installation
# # (network, broadcast and gateway are optional)
# auto eth0
# iface eth0 inet static
#         address 192.168.0.100
#         netmask 255.255.255.0
#         network 192.168.0.0
#         broadcast 192.168.0.255
#         gateway 192.168.0.1
####