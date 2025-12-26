#!/bin/bash
set -ex

############################################
# 0. Wait for network to fully come up
############################################
sleep 10

############################################
# 1. Update OS
############################################
yum update -y

############################################
# 2. Install Docker
############################################
yum install -y docker
systemctl enable docker
systemctl start docker
usermod -aG docker ec2-user

############################################
# 3. Install AWS CLI (needed for ECR login)
############################################
yum install -y awscli

############################################
# 4. Install SSM Agent (fix OFFLINE status)
############################################
yum install -y https://s3.ap-south-1.amazonaws.com/amazon-ssm-ap-south-1/latest/linux_amd64/amazon-ssm-agent.rpm || true
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

############################################
# 5. Login to ECR (uses EC2 IAM role)
############################################
aws ecr get-login-password --region ap-south-1 \
  | docker login --username AWS --password-stdin 381491835701.dkr.ecr.ap-south-1.amazonaws.com

############################################
# 6. Pull latest backend image
############################################
docker pull 381491835701.dkr.ecr.ap-south-1.amazonaws.com/advaitam-backend:latest

############################################
# 7. Stop old containers if exist
############################################
docker stop advaitam-backend || true
docker rm advaitam-backend || true

############################################
# 8. Run backend container
############################################
docker run -d \
  --name advaitam-backend \
  --restart unless-stopped \
  -p 5000:5000 \
  -e PORT=5000 \
  -e FRONTEND_URL="https://advaitam.monkweb.tech" \
  381491835701.dkr.ecr.ap-south-1.amazonaws.com/advaitam-backend:latest

############################################
# 9. Validate health endpoint internally
############################################
sleep 5
curl http://localhost:5000/api/health || echo "Health check failed but container started"
