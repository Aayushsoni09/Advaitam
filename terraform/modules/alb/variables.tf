variable "project_name" {}
variable "vpc_id" {}
variable "subnet_ids" { type = list(string) }
variable "backend_sg_id" {}
variable "acm_certificate_arn" {}