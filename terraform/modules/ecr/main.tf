resource "aws_ecr_repository" "this" {
  name = "${var.project_name}-backend"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  force_delete = true # OK for non-prod; disable later

  tags = {
    Name        = "${var.project_name}-ecr"
    Environment = var.environment
  }
}
