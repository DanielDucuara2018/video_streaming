#!/bin/bash
#Installing Docker

#requierements
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin git

# start docker service
sudo systemctl start docker
sudo systemctl status docker

# config docker service
sudo usermod -aG docker $(whoami)
sudo chmod 666 /var/run/docker.sock

# run apparrs + nginx + portainer containers
git clone https://github.com/DanielDucuara2018/video_streaming.git /opt/video_streaming
docker compose -f /opt/video_streaming/docker-compose.apparr.yml up -d

sudo unlink /etc/resolv.conf
sudo cat /etc/resolv.conf <<EOF >sudo
nameserver 192.168.1.100
nameserver 192.168.2.1
search streaming.home
EOF
