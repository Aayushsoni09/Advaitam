# resource "aws_iam_service_linked_role" "opensearch" {
#   aws_service_name = "opensearchservice.amazonaws.com"
# }

# SECURITY GROUP FOR DATA ---
resource "aws_security_group" "data_sg" {
  name        = "${var.project_name}-data-sg"
  description = "Allow Redis & OpenSearch from Backend only"
  vpc_id      = var.vpc_id

  # Allow Redis (6379) from Backend SG
  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [var.backend_sg_id]
  }

  # Allow OpenSearch (443) from Backend SG
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [var.backend_sg_id]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- 2. ELASTICACHE (REDIS) ---
resource "aws_elasticache_subnet_group" "redis_subnet" {
  name       = "${var.project_name}-redis-subnet"
  # We need subnet IDs here. For simplicity in default VPC, we can use a data source in root 
  # but often it's easier to pass them. For now, let's assume we pass subnet_ids variable 
  # or rely on default behavior if possible (but subnet group is required).
  # *Correction:* We will fetch subnets in the root main.tf and pass them here.
  subnet_ids = var.subnet_ids 
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${var.project_name}-redis"
  engine               = "redis"
  node_type            = "cache.t3.micro"  # Free Tier Eligible
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.2"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet.name
  security_group_ids   = [aws_security_group.data_sg.id]
}

# --- 3. OPENSEARCH (SEARCH ENGINE) ---
resource "aws_opensearch_domain" "search" {
  domain_name    = "${var.project_name}-search"
  engine_version = "OpenSearch_1.3" # Stable & Free Tier friendly
#   depends_on = [aws_iam_service_linked_role.opensearch]
  cluster_config {
    instance_type = "t3.small.search" # Free Tier Eligible
    instance_count = 1
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
    volume_type = "gp2"
  }
  
  # VPC Access (Private)
  vpc_options {
    subnet_ids         = [var.subnet_ids[0]] # Put in the first subnet
    security_group_ids = [aws_security_group.data_sg.id]
  }

  # Access Policy: Allow access only from within the VPC (Loose policy relies on SG)
  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = "es:*"
        Resource = "arn:aws:es:ap-south-1:${data.aws_caller_identity.current.account_id}:domain/${var.project_name}-search/*"
      }
    ]
  })
}

# Helper to get Account ID for the policy
data "aws_caller_identity" "current" {}