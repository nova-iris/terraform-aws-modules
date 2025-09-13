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
  type        = list(any)
  default     = []
}

variable "network_configuration" {
  description = "Network configuration for the service"
  type        = map(any)
  default     = {}
}

variable "load_balancer" {
  description = "Load balancer configuration"
  type        = map(any)
  default     = {}
}

variable "deployment_maximum_percent" {
  description = "Upper limit on the number of tasks running during a deployment"
  type        = number
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  description = "Lower limit on the number of tasks running during a deployment"
  type        = number
  default     = 100
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

variable "enable_execute_command" {
  description = "Whether to enable execute command functionality"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}