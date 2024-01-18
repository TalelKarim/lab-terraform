#!/bin/bash
sudo apt-get update -y 
sudo apt-get install -y git
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo touch tuto.txt
sudo chmod 777 /var/run/docker.sock
sudo docker pull talelch/pixalion_client:v1
sudo docker run --name pixalion_front -p 3000:3000 talelch/pixalion_client:v1
