terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1"
}

module "s3" {
  source = "../../.."

  bucket_name = "basic-s3-bucket-${random_suffix.unique.result}"
  
  tags = {
    Environment = "dev"
    Project     = "basic-s3-example"
    Purpose     = "storage"
  }
}

resource "random_string" "unique" {
  length  = 8
  special = false
  upper   = false
}

resource "random_suffix" "unique" {
  length = 8
}