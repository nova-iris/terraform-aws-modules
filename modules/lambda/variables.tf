variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "lambda-function"
}

variable "description" {
  description = "Description of the Lambda function"
  type        = string
  default     = "Lambda function created by Terraform"
}

variable "source_file" {
  description = "Path to the source file for the Lambda function"
  type        = string
  default     = "lambda_function.py"
}

variable "handler" {
  description = "Handler for the Lambda function"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "runtime" {
  description = "Runtime for the Lambda function"
  type        = string
  default     = "python3.9"
}

variable "execution_role_arn" {
  description = "ARN of the execution role for the Lambda function"
  type        = string
  default     = null
}

variable "create_execution_role" {
  description = "Whether to create an execution role for the Lambda function"
  type        = bool
  default     = true
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "subnet_ids" {
  description = "List of subnet IDs for VPC configuration"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of security group IDs for VPC configuration"
  type        = list(string)
  default     = []
}

variable "log_retention_in_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 14
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}