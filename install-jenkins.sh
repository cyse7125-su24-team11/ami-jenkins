#!/bin/bash

# Install Java

sudo apt update
sudo apt -y upgrade
sudo apt -y install fontconfig openjdk-17-jre gh


# Install npm

curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs npm

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
sleep 20

# Install Jenkins plugins
export JENKINS_CLI_JAR="/usr/share/jenkins/jenkins-cli.jar"
export JENKINS_URL="http://localhost:8080"

# Download Jenkins CLI jar
sudo wget -O $JENKINS_CLI_JAR http://localhost:8080/jnlpJars/jenkins-cli.jar

# Get Jenkins initial admin password
JENKINS_ADMIN_PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
export JENKINS_ADMIN_PASSWORD
# Install desired plugins
sudo java -jar $JENKINS_CLI_JAR -s $JENKINS_URL -auth admin:$JENKINS_ADMIN_PASSWORD install-plugin git github github-api job-dsl workflow-job configuration-as-code credentials workflow-aggregator conventional-commits github-branch-source

sudo systemctl restart jenkins

sleep 20
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
sudo cp /tmp/caddyconfig/Caddyfile /etc/caddy/Caddyfile
rm /tmp/caddyconfig/Caddyfile

sudo cp /tmp/caddyconfig/caddy.service /etc/systemd/system/caddy.service
rm /tmp/caddyconfig/caddy.service


sudo cp /tmp/jenkins-config/jenkins.yaml /var/lib/jenkins/jenkins.yaml
rm /tmp/jenkins-config/jenkins.yaml
sudo chown jenkins:jenkins /var/lib/jenkins/jenkins.yaml
sudo chmod 600 /var/lib/jenkins/jenkins.yaml


sudo cp /tmp/jenkins-config/jenkins.service /etc/systemd/system/jenkins.service
rm /tmp/jenkins-config/jenkins.service

sudo cp /tmp/jenkins-config/job.groovy /var/lib/jenkins/plugins/job-dsl/job.groovy
rm /tmp/jenkins-config/job.groovy
sudo chown jenkins:jenkins /var/lib/jenkins/plugins/job-dsl/job.groovy
sudo chmod 600 /var/lib/jenkins/plugins/job-dsl/job.groovy


sudo systemctl daemon-reload
sudo systemctl enable --now caddy


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


#give permissions to jenkins user to run docker cmds
sudo usermod -a -G docker jenkins

# Daemon json
sudo cp /tmp/jenkins-config/daemon.json /etc/docker/daemon.json

# Restart Jenkins to apply docker permissions on jenkins user
sudo systemctl restart jenkins

docker run --privileged --rm tonistiigi/binfmt --install all
# Restart Docker
sudo systemctl restart docker