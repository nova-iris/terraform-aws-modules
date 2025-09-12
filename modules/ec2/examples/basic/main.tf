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

  name = "basic-ec2-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = "dev"
    Project     = "basic-ec2-example"
  }
}

module "ec2" {
  source = "../../.."

  name           = "basic-ec2-instance"
  ami            = data.aws_ami.amazon_linux_2.id
  instance_type  = "t3.micro"
  key_name       = null
  
  subnet_id                      = module.vpc.public_subnets[0]
  vpc_security_group_ids         = [aws_security_group.ec2_sg.id]
  associate_public_ip_address    = true

  tags = {
    Environment = "dev"
    Project     = "basic-ec2-example"
    Purpose     = "web-server"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "basic-ec2-sg"
  description = "Security group for basic EC2 instance"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Environment = "dev"
    Project     = "basic-ec2-example"
    Purpose     = "web-server-sg"
  }
}