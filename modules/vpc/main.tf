terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.name
  cidr = var.cidr

  azs              = var.azs
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  database_subnets = var.database_subnets

  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  enable_vpn_gateway = var.enable_vpn_gateway

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )

  public_subnet_tags = merge(
    {
      "Type" = "Public"
    },
    var.public_subnet_tags
  )

  private_subnet_tags = merge(
    {
      "Type" = "Private"
    },
    var.private_subnet_tags
  )

  database_subnet_tags = merge(
    {
      "Type" = "Database"
    },
    var.database_subnet_tags
  )
}