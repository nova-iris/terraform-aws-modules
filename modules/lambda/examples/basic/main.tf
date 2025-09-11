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

module "lambda_function" {
  source = "../../.."

  function_name = "example-lambda-function"
  description   = "Example Lambda function"
  source_file   = "${path.module}/lambda_function.py"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  environment_variables = {
    ENVIRONMENT = "development"
    LOG_LEVEL   = "INFO"
  }

  log_retention_in_days = 30

  tags = {
    Environment = "development"
    Project     = "lambda-example"
  }
}