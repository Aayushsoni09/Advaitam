terraform {
  # This tells Terraform: "Don't look on my laptop, look in S3"
  backend "s3" {
    bucket         = "advaitam-terraform-state-backend"  
    key            = "advaitam/prod/terraform.tfstate"   # Path inside the bucket
    region         = "ap-south-1"
    dynamodb_table = "advaitam-terraform-locks"        
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# DATA SOURCES (Get VPC & Subnets)
data "aws_vpc" "default" {
  default = true
}

# Get the available zones (e.g., ap-south-1a, ap-south-1b)
data "aws_availability_zones" "available" {
  state = "available"
}

# Get ALL Subnets in Zone A (ap-south-1a)
data "aws_subnets" "vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
locals {
  alb_subnets = length(data.aws_subnets.vpc_subnets.ids) >= 2 ? slice(data.aws_subnets.vpc_subnets.ids, 0, 2): data.aws_subnets.vpc_subnets.ids
}

# Call the Frontend Module
module "frontend" {
  source              = "./modules/frontend"
  project_name        = var.project_name
  domain_name         = var.domain_name
  acm_certificate_arn = var.acm_certificate_arn
  alb_dns_name       = module.alb.alb_dns_name
}


#  Call the Backend Module
module "backend" {
  source       = "./modules/backend"
  project_name = var.project_name
  vpc_id       = data.aws_vpc.default.id
  my_ip        = "103.185.243.206/32" 
  alb_security_group_id = module.alb.security_group_id
  subnet_id             = data.aws_subnets.vpc_subnets.ids[0]
}
# DATA MODULE (Redis + OpenSearch)
module "data" {
  source        = "./modules/data"
  project_name  = var.project_name
  vpc_id        = data.aws_vpc.default.id
  subnet_ids    = [data.aws_subnets.vpc_subnets.ids[0]]
  backend_sg_id = module.backend.security_group_id # We need to expose this output!
}

# ALB MODULE
module "alb" {
  source              = "./modules/alb"
  project_name        = var.project_name
  vpc_id              = data.aws_vpc.default.id
  subnet_ids          = local.alb_subnets
  backend_sg_id       = module.backend.security_group_id
  acm_certificate_arn = var.acm_certificate_arn
}

# ATTACH EC2 TO ALB (Crucial Step!)
resource "aws_lb_target_group_attachment" "backend_attach" {
  target_group_arn = module.alb.target_group_arn
  target_id        = module.backend.instance_id 
  port             = 5000
}
output "api_endpoint" {
  value = "https://${module.alb.alb_dns_name}"
}