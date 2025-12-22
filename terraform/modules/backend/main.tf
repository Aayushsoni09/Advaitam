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

# --- 3. EC2 INSTANCE ---
resource "aws_instance" "app_server" {
  ami           = "ami-00ca570c1b6d79f36" 
  instance_type = "t2.micro"             
  key_name               = aws_key_pair.kp.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  
  # Attach the startup script
  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "${var.project_name}-ec2"
  }
}