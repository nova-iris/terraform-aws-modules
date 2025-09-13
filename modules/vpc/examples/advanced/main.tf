terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../../vpc"

  name = "advanced-vpc"
  cidr = "10.10.0.0/16"

  azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets  = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  public_subnets   = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
  database_subnets = ["10.10.201.0/24", "10.10.202.0/24", "10.10.203.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true
  enable_vpn_gateway     = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "staging"
    Project     = "advanced-vpc-example"
    Owner       = "platform-team"
  }

  public_subnet_tags = {
    "Type"                          = "Public"
    "kubernetes.io/cluster/example" = "shared"
    "kubernetes.io/role/elb"        = "1"
  }

  private_subnet_tags = {
    "Type"                            = "Private"
    "kubernetes.io/cluster/example"   = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }

  database_subnet_tags = {
    "Type" = "Database"
  }
}