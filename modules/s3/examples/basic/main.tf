terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "random_string" "unique" {
  length  = 8
  special = false
  upper   = false
}

module "s3" {
  source = "../../../s3"

  bucket_name = "basic-s3-bucket-${random_string.unique.result}"

  tags = {
    Environment = "dev"
    Project     = "basic-s3-example"
    Purpose     = "storage"
  }
}