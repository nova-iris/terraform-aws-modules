terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "local_file" "lambda_function" {
  content  = <<-EOT
  import json
  
  def lambda_handler(event, context):
      return {
          'statusCode': 200,
          'headers': {
              'Content-Type': 'application/json'
          },
          'body': json.dumps({
              'message': 'Hello from basic Lambda function!',
              'timestamp': '2024-01-01T00:00:00Z',
              'event': event
          })
      }
  EOT
  filename = "${path.module}/lambda_function.py"
}

module "lambda" {
  source = "../../../lambda"

  function_name = "basic-lambda-function"
  description   = "Basic Lambda function for validation"
  runtime       = "python3.11"
  handler       = "lambda_function.lambda_handler"
  source_file   = local_file.lambda_function.filename

  create_execution_role = true

  environment_variables = {
    ENVIRONMENT = "dev"
    LOG_LEVEL   = "INFO"
  }

  tags = {
    Environment = "dev"
    Project     = "basic-lambda-example"
    Purpose     = "validation-function"
  }
}