#!/bin/bash
# cp /etc/ufw/user.rules /etc/ufw/user.rules.bak

# Traz inalterados em 5 minutos
echo "mv /etc/ufw/user.rules.bak /etc/ufw/user.rules && ufw enable" | at now + 3min
echo "mv /etc/ufw/user.rules6.bak /etc/ufw/user6.rules && ufw enable" | at now + 3min
ufw enable