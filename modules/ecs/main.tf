terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws"
  version = ">= 5.0"

  cluster_name = var.cluster_name

  tags = var.tags
}

module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = ">= 5.0"

  create = var.create_service

  name        = var.service_name
  cluster_arn = module.ecs_cluster.cluster_arn

  cpu    = var.task_cpu
  memory = var.task_memory

  container_definitions = var.container_definitions

  network_configuration = var.network_configuration

  load_balancer = var.load_balancer

  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  desired_count = var.desired_count

  launch_type = var.launch_type

  enable_execute_command = var.enable_execute_command

  tags = var.tags

  depends_on = [module.ecs_cluster]
}