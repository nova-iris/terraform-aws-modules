terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "s3_bucket" {
  source = "../../.."

  bucket_name        = "example-s3-bucket-unique-name"
  acl                = "private"
  versioning_enabled = true
  sse_algorithm      = "AES256"

  lifecycle_rules = [
    {
      id      = "log-lifecycle"
      enabled = true
      expiration = {
        days = 365
      }
      transition = {
        days          = 30
        storage_class = "STANDARD_IA"
      }
    }
  ]

  tags = {
    Environment = "development"
    Project     = "s3-example"
    Purpose     = "storage"
  }
}