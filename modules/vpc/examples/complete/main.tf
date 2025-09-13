terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../../vpc"

  name = "complete-vpc"
  cidr = "172.16.0.0/16"

  azs              = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  private_subnets  = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24", "172.16.4.0/24"]
  public_subnets   = ["172.16.101.0/24", "172.16.102.0/24", "172.16.103.0/24", "172.16.104.0/24"]
  database_subnets = ["172.16.201.0/24", "172.16.202.0/24", "172.16.203.0/24", "172.16.204.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true
  enable_vpn_gateway     = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  customer_gateways = {
    "my-gw" = {
      bgp_asn    = 65000
      ip_address = "1.2.3.4"
    }
  }

  tags = {
    Environment = "production"
    Project     = "complete-vpc-example"
    Owner       = "infrastructure-team"
    CostCenter  = "engineering"
    Compliance  = "SOC2"
  }

  public_subnet_tags = {
    "Type"                       = "Public"
    "Network"                    = "External"
    "kubernetes.io/cluster/prod" = "shared"
    "kubernetes.io/role/elb"     = "1"
    "Backup"                     = "daily"
  }

  private_subnet_tags = {
    "Type"                            = "Private"
    "Network"                         = "Internal"
    "kubernetes.io/cluster/prod"      = "shared"
    "kubernetes.io/role/internal-elb" = "1"
    "Backup"                          = "daily"
  }

  database_subnet_tags = {
    "Type"       = "Database"
    "Network"    = "Database"
    "Encryption" = "enabled"
    "Backup"     = "hourly"
  }
}