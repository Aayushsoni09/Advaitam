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


# Call the Frontend Module
module "frontend" {
  source              = "./modules/frontend"
  project_name        = var.project_name
  domain_name         = var.domain_name
  acm_certificate_arn = var.acm_certificate_arn
}