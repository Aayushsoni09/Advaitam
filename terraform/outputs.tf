output "website_bucket" {
  value = module.frontend.bucket_name
}

output "cloudfront_url" {
  value = module.frontend.cloudfront_domain
}

output "live_url" {
  value = "https://${var.domain_name}"
}
output "ecr_repository_url" {
  value = module.ecr.repository_url
}
