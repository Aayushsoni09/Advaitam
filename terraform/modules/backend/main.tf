# --- 1. SECURITY GROUPS (The Firewall) ---

resource "aws_security_group" "backend_sg" {
  name        = "${var.project_name}-backend-sg"
  description = "Allow HTTP/SSH for Backend"
  vpc_id      = var.vpc_id

  # Inbound: Allow SSH only from YOUR IP (Security Best Practice)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
    description = "SSH from My Laptop"
  }

  # Inbound: Allow HTTP (Port 80) from Anywhere (For testing, later restrict to CloudFront)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP Traffic"
  }

  # Inbound: Allow Node.js Port 
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    security_groups = [var.alb_security_group_id]
    description     = "Traffic from Load Balancer"
  }

  # Outbound: Allow Server to talk to the Internet (Install updates, talk to Mongo)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-backend-sg"
  }
}

# --- 2. SSH KEY PAIR ---
# This generates a key file so you can login. 
# In production, you'd import your own public key.
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "${var.project_name}-key"
  public_key = tls_private_key.pk.public_key_openssh
}

# Save the private key to your computer so you can use it
resource "local_file" "ssh_key" {
  filename        = "${path.module}/../../${var.project_name}-key.pem"
  content         = tls_private_key.pk.private_key_pem
  file_permission = "0400"
}

# DynamoDB policy

resource "aws_iam_policy" "dynamodb_access" {
  name        = "${var.project_name}-dynamodb-access"
  description = "Allow EC2 to read/write Products table in DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem",
          "dynamodb:BatchWriteItem"
        ],
        Resource = "arn:aws:dynamodb:ap-south-1:${var.account_id}:table/Products"
      }
    ]
  })
}


# --- 3. EC2 INSTANCE ---
resource "aws_instance" "app_server" {
  ami           = "ami-00ca570c1b6d79f36" 
  instance_type = "t2.micro"             
  key_name               = aws_key_pair.kp.key_name
  subnet_id              = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  # Attach the startup script
  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "${var.project_name}-ec2"
    Role = "backend"
  }
}
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_read" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "dynamodb_policy_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.dynamodb_access.arn
}

# Lambda + IAM + DynamoDB Stream Trigger

resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-dynamodb-sync-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.project_name}-ddb-opensearch-sync-policy"
  description = "Allows Lambda to read DynamoDB Streams + write to OpenSearch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:DescribeStream",
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator",
          "dynamodb:ListStreams"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "es:ESHttpGet",
          "es:ESHttpPut",
          "es:ESHttpPost"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# ZIP the Lambda code automatically
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/dynamodb-to-opensearch-sync.js"
  output_path = "${path.module}/lambda/dynamodb-to-opensearch-sync.zip"
}

resource "aws_lambda_function" "ddb_to_opensearch" {
  function_name = "${var.project_name}-ddb-sync-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "dynamodb-to-opensearch-sync.handler"
  runtime       = "nodejs20.x"
  filename      = data.archive_file.lambda_zip.output_path

  environment {
    variables = {
      OPENSEARCH_ENDPOINT = var.opensearch_endpoint != "" ? var.opensearch_endpoint : "NOT_CONFIGURED"
      INDEX_NAME          = var.index_name
    }
  }
}

# DynamoDB Stream Trigger
data "aws_dynamodb_table" "products" {
  name = var.dynamodb_table_name
}

resource "aws_lambda_event_source_mapping" "ddb_trigger" {
  event_source_arn  = data.aws_dynamodb_table.products.stream_arn
  function_name     = aws_lambda_function.ddb_to_opensearch.arn
  starting_position = "LATEST"
  batch_size        = 100
}
