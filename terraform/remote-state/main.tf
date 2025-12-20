provider "aws" {
  region = "ap-south-1"
}

# 1. S3 Bucket to store the State File
resource "aws_s3_bucket" "terraform_state" {
  bucket = "advaitam-terraform-state-backend" 
  
  # Prevent accidental deletion of this critical bucket
  lifecycle {
    prevent_destroy = true
  }
}

# Enable Versioning (Critical: If state gets corrupted, you can roll back)
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 2. DynamoDB Table for Locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "advaitam-terraform-locks"
  billing_mode = "PAY_PER_REQUEST" # Free Tier friendly (pay only when used)
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# OUTPUTS (You will need these for Step 4)
output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_state.id
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}