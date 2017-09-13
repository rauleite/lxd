from ubuntu:17.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install ubuntu-server -y && \
    apt-get install sudo -y && \
    apt-get install openssh-server -y

RUN apt-get install nano -y

ARG user

ENV user $user
ENV user_dir /home/$user

RUN sudo adduser $user --disabled-password --gecos "" && \  
    echo $user"  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir $user_dir/.ssh && \
    chmod 700 $user_dir/.ssh && \
    touch $user_dir/.ssh/authorized_keys && \
    chmod 600 $user_dir/.ssh/authorized_keys

# COPY docker-entrypoint.sh /usr/local/bin/
# RUN chmod +x /usr/local/bin/docker-entrypoint.sh
# ENTRYPOINT docker-entrypoint.sh

EXPOSE 22
USER $user
WORKDIR $user_dir


#build 
# docker build --tag bd-server --build-arg user=rleite  .

# run
# docker run --name ct-server -p 22 -it bd-server /bin/bash
