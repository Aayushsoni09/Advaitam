variable "aws_region" {
  default = "ap-south-1" 
}

variable "project_name" {
  default = "advaitam"
}

variable "domain_name" {
  default = "advaitam.monkweb.tech"
}

variable "acm_certificate_arn" {
  description = "The ARN of your EXISTING ACM certificate"
  type        = string
  # You will paste your ARN in a terraform.tfvars file or command line
}