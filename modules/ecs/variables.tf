variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "ecs-cluster"
}

variable "create_service" {
  description = "Whether to create ECS service"
  type        = bool
  default     = true
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "ecs-service"
}


variable "task_cpu" {
  description = "CPU units for the task"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory (MB) for the task"
  type        = number
  default     = 512
}

variable "container_definitions" {
  description = "Container definitions for the task"
  type        = map(any)
  default     = {}
}


variable "desired_count" {
  description = "Number of instances of the task to place and keep running"
  type        = number
  default     = 1
}

variable "launch_type" {
  description = "Launch type for the service"
  type        = string
  default     = "FARGATE"
}

variable "subnet_ids" {
  description = "Subnet IDs for the service (required for FARGATE)"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "Security group IDs for the service (required for FARGATE)"
  type        = list(string)
  default     = []
}


variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}