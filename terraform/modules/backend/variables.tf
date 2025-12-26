variable "project_name" {}
variable "environment" { default = "prod" }
variable "vpc_id" {
  description = "The ID of the Default VPC"
  type        = string
}
variable "my_ip" {
  description = "Your personal IP address for SSH access (e.g., 1.2.3.4/32)"
  type        = string
}
variable "alb_security_group_id" {
  description = "Security group ID for the Application Load Balancer"
  type        = string
  default     = null # Optional default to prevent errors if not passed initially
}
variable "subnet_id" {
  description = "The specific subnet to deploy the EC2 instance in"
  type        = string
}
variable "account_id"{
  description = "The AWS Account ID"
  type        = string
}
variable "opensearch_endpoint" {
  description = "OpenSearch endpoint URL"
}

variable "index_name" {
  default = "products"
}