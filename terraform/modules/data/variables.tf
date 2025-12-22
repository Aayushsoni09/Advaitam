variable "project_name" {}
variable "vpc_id" {}
variable "backend_sg_id" {
  description = "Security Group ID of the EC2 instance (to allow access)"
  type        = string
}

variable "subnet_ids" {
  type = list(string)
}