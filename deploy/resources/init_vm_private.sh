#!/bin/bash
#Installing Docker
# run docker-compose arrs apps
bash ./install_docker.sh
git clone https://github.com/DanielDucuara2018/video_streaming.git /opt/video_streaming
docker compose -f /opt/video_streaming/docker-compose.yml up -d