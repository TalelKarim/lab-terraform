#!/bin/bash

# Update and install required packages
sudo apt-get update -y
sudo apt install -y  net-tools
sudo apt install -y mysql-client-core-8.0
sudo apt-get install -y git
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

# Set permissions for Docker socket
sudo chmod 777 /var/run/docker.sock

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose

# Define the Docker Compose content using a here document
sudo tee docker-compose.yml > /dev/null <<'EOF'
version: "3.3"
services:
  three-tier-front:
    container_name: three-tier-front
    image: talelch/three-tier-front
    environment:
      - SERVER_PORT=${SERVER_PORT}
      - PORT=${PORT}
    ports:
      - "8081:8081"
    networks:
      - my-network
    depends_on:
      - three-tier-backend

  three-tier-backend:
    container_name: three-tier-backend
    image: talelch/three-tier-backend
    environment:
      - DB_HOST=${DB_HOST}
      - DB_USERNAME=${DB_USERNAME}
      - DB_PWD=${DB_PWD}
      - DBNAME=${DBNAME}
    ports:
      - "8080:8080"
    networks:
      - my-network
networks:
  my-network:
    driver: bridge

EOF

# Run Docker Compose
sudo docker-compose up -d
