#!/bin/bash
# 1. Update the OS
sudo yum update -y

# 2. Install Docker
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user

# 3. Install Docker Compose (Latest Version)
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 4. Install Git (To pull your repo)
sudo yum install -y git

# 5. Enable Docker to start on boot
sudo systemctl enable docker