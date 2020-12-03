# fixed ubuntu image
FROM ubuntu:focal

# arugments
ARG ROOT_PASSWORD=ubuntu
ARG USER_NAME=ubuntu
ARG USER_PASSWORD=ubuntu

# disables package installation prompt
ENV DEBIAN_FRONTEND noninteractive

# fixes error message when using sudo
RUN echo "Set disable_coredump false" >> /etc/sudo.conf

# packages list
RUN apt update && apt -y install supervisor sudo openssh-server docker.io docker-compose

# root
RUN echo "root:$ROOT_PASSWORD" | chpasswd

# user
RUN useradd -m "$USER_NAME"
RUN echo "$USER_NAME:$USER_PASSWORD" | chpasswd
RUN chsh -s /bin/bash $USER_NAME
RUN echo "\n$USER_NAME    ALL=(ALL:ALL) ALL" >> /etc/sudoers
RUN usermod -aG docker $USER_NAME
RUN newgrp docker

# ssh server
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
# fix sshd bug
RUN mkdir -p /var/run/sshd

# write script to setup key pair
RUN mkdir /scripts/
RUN touch /scripts/keypair.sh
RUN echo '#!/bin/bash' > /scripts/keypair.sh
RUN echo 'mkdir ~/.ssh' >> /scripts/keypair.sh
RUN echo 'ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -N ""' >> /scripts/keypair.sh
RUN echo 'cat ~/.ssh/id_ed25519.pub > ~/.ssh/authorized_keys' >> /scripts/keypair.sh
RUN echo 'eval $(ssh-agent -s) && ssh-add ~/.ssh/id_ed25519' >> /scripts/keypair.sh
RUN chmod o+rx /scripts/keypair.sh

# configure startup commands
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# execute supervisord to start ssh server and docker deamon
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]