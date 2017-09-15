#!/bin/bash
mkdir -p /etc/ufw/backup
# Se quebrar, recuperar aqui
cp /etc/ufw/user.rules /etc/ufw/backup/user.rules_$(date +"%m_%d_%Y")
# Inalterado Temp
cp /etc/ufw/user.rules /etc/ufw/user.rules.bak

# IPV6
cp /etc/ufw/user6.rules /etc/ufw/backup/user6.rules_$(date +"%m_%d_%Y")
cp /etc/ufw/user6.rules /etc/ufw/user6.rules.bak