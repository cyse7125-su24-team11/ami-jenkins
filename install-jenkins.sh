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

# Wait for Jenkins to start
sleep 30

# Install Jenkins plugins
export JENKINS_CLI_JAR="/usr/share/jenkins/jenkins-cli.jar"
export JENKINS_URL="http://localhost:8080"

# Download Jenkins CLI jar
sudo wget -O $JENKINS_CLI_JAR http://localhost:8080/jnlpJars/jenkins-cli.jar

# Get Jenkins initial admin password
export JENKINS_ADMIN_PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)

# Install desired plugins
sudo java -jar $JENKINS_CLI_JAR -s $JENKINS_URL -auth admin:$JENKINS_ADMIN_PASSWORD install-plugin git github github-api job-dsl:1.87 workflow-job:1426.v2ecb_a_a_42fd46


# Install caddy

wget https://github.com/caddyserver/caddy/releases/download/v2.7.6/caddy_2.7.6_linux_amd64.tar.gz -P /tmp
sudo tar -xvzf /tmp/caddy_2.7.6_linux_amd64.tar.gz -C /usr/bin
sudo groupadd --system caddy
sudo useradd --system \
    --gid caddy \
    --create-home \
    --home-dir /var/lib/caddy \
    --shell /usr/sbin/nologin \
    --comment "Caddy web server" \
    caddy

sudo mkdir -p /etc/caddy
sudo cp /tmp/Caddyfile /etc/caddy/Caddyfile
rm /tmp/Caddyfile

sudo cp /tmp/caddy.service /etc/systemd/system/caddy.service
rm /tmp/caddy.service

sudo cp /tmp/jenkins.yaml /var/lib/jenkins/jenkins.yaml
rm /tmp/jenkins.yaml

sudo cp /tmp/jenkins.service /etc/systemd/system/jenkins.service
rm /tmp/jenkins.service

sudo cp /tmp/job.groovy /var/lib/jenkins/plugins/job-dsl/job.groovy
rm /tmp/job.groovy

sudo cp /tmp/Jenkinsfile /var/lib/jenkins/plugins/job-dsl/Jenkinsfile
rm /tmp/Jenkinsfile

sudo systemctl daemon-reload
sudo systemctl enable --now caddy


# Restart Jenkins to apply the plugins
sudo systemctl restart jenkins

# Install Docker

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y