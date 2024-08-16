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
sudo tee /etc/resolv.conf >/dev/null <<EOF
nameserver 192.168.1.100
nameserver 192.168.2.1
search streaming.home
EOF

sudo chown -R 1000:1000 /opt/video_streaming/data/

# create Root Certificate
# sudo chmod 0700 /opt/video_streaming/resources/setup_ca.sh
# /opt/video_streaming/resources/setup_ca.sh

# create web site Certificate
# sudo chmod 0700 /opt/video_streaming/resources/setup_cert.sh
# /opt/video_streaming/resources/setup_cert.sh

# restart nginx service
# docker restart nginx
