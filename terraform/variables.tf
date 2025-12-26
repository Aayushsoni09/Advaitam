
variable "project_name" {
  description = "The project name"
  type        = string
}
variable "domain_name" {
  description = "The domain name for website"
  type        = string
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
}

variable "acm_certificate_arn" {
  description = "The ARN of your EXISTING ACM certificate"
  type        = string
}
variable "environment" {
  type    = string
  default = "prod"
}
variable "account_id"{
  description = "The AWS Account ID"
  type        = string
  default = "381491835701"
}