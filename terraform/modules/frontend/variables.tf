variable "project_name" {
  description = "Name of the project (e.g., advaitam)"
  type        = string
}

variable "domain_name" {
  description = "The custom domain name (e.g., advaitam.monkweb.tech)"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN of the existing ACM certificate"
  type        = string
}
variable "alb_dns_name" {
  description = "DNS name of the backend ALB"
  type        = string
}