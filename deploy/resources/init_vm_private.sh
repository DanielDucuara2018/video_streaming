#!/bin/bash
#Installing Docker
# run docker-compose arrs apps
sudo dnf check-update
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin git
sudo systemctl start docker
sudo systemctl status docker
sudo usermod -aG docker $(whoami)
sudo chmod 666 /var/run/docker.sock
git clone https://github.com/DanielDucuara2018/video_streaming.git /opt/video_streaming
docker compose -f /opt/video_streaming/docker-compose.apparr.yml up -d