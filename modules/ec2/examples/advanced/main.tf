terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "vpc" {
  source = "../../../vpc"

  name = "advanced-ec2-vpc"
  cidr = "10.10.0.0/16"

  azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets  = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  public_subnets   = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
  database_subnets = ["10.10.201.0/24", "10.10.202.0/24", "10.10.203.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "staging"
    Project     = "advanced-ec2-example"
    Owner       = "platform-team"
  }
}

module "ec2" {
  source = "../../../ec2"

  name          = "advanced-ec2-instance"
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.medium"
  key_name      = "staging-key"
  monitoring    = true

  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = false

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Advanced EC2 Instance</h1>" > /var/www/html/index.html
              EOF

  root_block_device = [
    {
      delete_on_termination = true
      encrypted             = true
      iops                  = 3000
      kms_key_id            = null
      volume_size           = 30
      volume_type           = "gp3"
    }
  ]

  ebs_block_device = [
    {
      delete_on_termination = true
      device_name           = "/dev/sdf"
      encrypted             = true
      iops                  = 5000
      kms_key_id            = null
      snapshot_id           = null
      volume_size           = 100
      volume_type           = "gp3"
    }
  ]

  tags = {
    Environment = "staging"
    Project     = "advanced-ec2-example"
    Purpose     = "web-server"
    Backup      = "daily"
    Monitoring  = "enabled"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "advanced-ec2-sg"
  description = "Security group for advanced EC2 instance"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
    description     = "SSH access from bastion"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    description     = "HTTPS access from ALB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Environment = "staging"
    Project     = "advanced-ec2-example"
    Purpose     = "web-server-sg"
  }
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Environment = "staging"
    Project     = "advanced-ec2-example"
    Purpose     = "bastion-sg"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Environment = "staging"
    Project     = "advanced-ec2-example"
    Purpose     = "alb-sg"
  }
}