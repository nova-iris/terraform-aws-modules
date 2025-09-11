terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1"
}

module "ec2_instance" {
  source = "../../"

  name           = "simple-ec2"
  instance_type  = "t3.micro"
  key_name       = "my-key-pair"
  monitoring     = true
  associate_public_ip_address = true

  tags = {
    Environment = "dev"
    Project     = "simple-ec2"
  }
}