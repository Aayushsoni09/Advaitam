#!/bin/bash
set -ex

# 1. Update OS
yum update -y

# 2. Install Docker
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

# 3. Install AWS CLI (needed for ECR login)
yum install -y awscli

# 4. Login to ECR (uses EC2 IAM role)
aws ecr get-login-password --region ap-south-1 \
  | docker login --username AWS --password-stdin 381491835701.dkr.ecr.ap-south-1.amazonaws.com

# 5. Pull backend image
docker pull 381491835701.dkr.ecr.ap-south-1.amazonaws.com/advaitam-backend:latest

# 6. Run backend container
docker run -d \
  --name advaitam-backend \
  --restart unless-stopped \
  -p 5000:5000 \
  -e PORT=5000 \
  -e FRONTEND_URL=https://advaitam.monkweb.tech \
  381491835701.dkr.ecr.ap-south-1.amazonaws.com/advaitam-backend:latest
