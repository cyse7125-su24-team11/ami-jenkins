#!/bin/bash

# Install Java

sudo apt update
sudo apt -y upgrade
sudo apt -y install fontconfig openjdk-17-jre

# Install Jenkins

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get -y install jenkins
sudo systemctl enable jenkins

# Install caddy

wget https://github.com/caddyserver/caddy/releases/download/v2.7.6/caddy_2.7.6_linux_amd64.tar.gz -P /tmp
tar -xvzf /tmp/caddy_2.7.6_linux_amd64.tar.gz -C /usr/bin
sudo groupadd --system caddy
sudo useradd --system \
    --gid caddy \
    --create-home \
    --home-dir /var/lib/caddy \
    --shell /usr/sbin/nologin \
    --comment "Caddy web server" \
    caddy

sudo cp /tmp/Caddyfile /etc/caddy/Caddyfile
rm /tmp/Caddyfile
sudo cp /tmp/caddy.service /etc/systemd/system/caddy.service
rm /tmp/caddy.service
sudo systemctl daemon-reload
sudo systemctl enable --now caddy
