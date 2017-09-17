







# sudo nano /etc/rc.local

# AWS - Node 1
sudo apt-get install vlan
sudo modprobe 8021q
sudo vconfig add eth0 10
sudo ip addr add 10.0.0.1/24 dev eth0.10
sudo service networking restart
sudo service apache2 restart

# GCloud - Node 2
sudo apt-get install vlan
sudo modprobe 8021q
sudo vconfig add ens4 10
sudo ip addr add 10.0.0.2/24 dev ens4.10
sudo service networking restart
sudo service apache2 restart

# GCloud - Proxy
sudo apt-get install vlan
sudo modprobe 8021q
sudo vconfig add ens4 10
sudo ip addr add 10.0.0.3/24 dev ens4.10
sudo service networking restart
sudo service haproxy restart
sudo apt-get install keepalived

# sudo nano /etc/sysctl.conf
# net.ipv4.ip_nonlocal_bind=1

# check ip provido pelo keepeavlived
# ip ad sh [eth0]













# Ver com keealive para High Avaiable (Ver necessidade de mais uma maquina)

# Fazer esta configuracao nas TRES maquinas
# https://wiki.ubuntu.com/vlan

# Se "service networking restart" nao funcionar:
# ip addr flush dev eth0.10 # Talvez isto ajude

# Seguir a parte de subir apache para 2 nodes e haproxy, daqui com consideracoes...
# https://pplware.sapo.pt/tutoriais/tutorial-balanceamento-de-carga-em-servidores-com-haproxy/
# Arquivo Proxy ficara assim:
#--------------
# global
#         log /dev/log   local0
#         log 127.0.0.1   local1 notice
#         maxconn 4096
#         user haproxy
#         group haproxy
#         daemon
 
# defaults
#         log     global
#         option  httplog
#         option  dontlognull
#         retries 3
#         option redispatch
#         maxconn 2000
#         contimeout     5000
#         clitimeout     50000
#         srvtimeout     50000
# 	mode http #define o modo de funcionamento do balanceador(1)
 
# listen webfarm 
# 	bind *:80 #apenas escuta neste IP do balanceador, e no porto 80
# 	stats enable	#activa as estatisticas do serviço (2)
# 	stats auth admin:admin	#autenticação nas estatisticas 
# 	acl url_test_dev path_beg /	#definição da acl
# 	use_backend testdev if url_test_dev	#associar a acl a um grupo de servers
 
# backend testdev	#define a farm de servers backend para o site test.dev
# 	balance roundrobin	#define o algoritmo de balanceamento
# 	server node1 18.220.249.68:80 check # define o servidor e porto e o parâmetro de Health check
# 	server node2 35.203.147.131:80 check # define o servidor e porto e o parâmetro de Health check
# ---------------

# Configuracao em caso de wan
# auto wlan0
# iface wlan0 inet dhcp
#     wpa-ssid bolsolula2018
#     wpa-psk xxxxxxxx

# Se der erro de nome muito grande
# ip link
# https://unix.stackexchange.com/a/328498





# HAproxy configs old

# global
#         log /dev/log   local0
#         log 127.0.0.1   local1 notice
#         maxconn 4096
#         user haproxy
#         group haproxy
#         daemon

# defaults
#         log     global
#         option  tcplog
#         option  dontlognull
#         retries 3
#         option redispatch
#         maxconn 2000
#         contimeout     5000
#         clitimeout     50000
#         srvtimeout     50000
#         mode tcp #define o modo de funcionamento do balanceador(1)


# frontend www
#         bind *:80
#         default_backend nginx_pool

# backend nginx_pool
#         balance roundrobin
#         mode tcp
#         #server web1 10.0.0.1:80 check
#         #server web2 10.0.0.2:80 check
#         server web1 18.220.178.187:80 check
#         server web2 35.197.54.19:80 check

# -----
# # Layer 7
# # listen webfarm
# #       bind *:80 #apenas escuta neste IP do balanceador, e no porto 80
# #       stats enable    #activa as estatisticas do serviço (2)
# #       stats auth admin:admin  #autenticação nas estatisticas
# #       acl url_test_dev path_beg /     #definição da acl
# #       use_backend testdev if url_test_dev     #associar a acl a um grupo de servers

# # backend testdev        #define a farm de servers backend para o site test.dev
# #       balance roundrobin      #define o algoritmo de balanceamento
# #       server node1 18.220.249.68:80 check # define o servidor e porto e o parâmetro de Health check
# #       server node2 35.203.147.131:80 check # define o servidor e porto e o parâmetro de Health check
