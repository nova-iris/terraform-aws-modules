terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = ">= 5.0"

  name           = var.name
  ami            = var.ami
  instance_type  = var.instance_type
  key_name       = var.key_name
  monitoring     = var.monitoring
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id      = var.subnet_id

  user_data = var.user_data
  user_data_base64 = var.user_data_base64

  iam_instance_profile = var.iam_instance_profile

  associate_public_ip_address = var.associate_public_ip_address

  root_block_device = var.root_block_device
  ebs_block_device = var.ebs_block_device

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )
}