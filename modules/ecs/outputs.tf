output "cluster_id" {
  description = "ECS Cluster ID"
  value       = module.ecs_cluster.cluster_id
}

output "cluster_arn" {
  description = "ECS Cluster ARN"
  value       = module.ecs_cluster.cluster_arn
}

output "cluster_name" {
  description = "ECS Cluster Name"
  value       = module.ecs_cluster.cluster_name
}

output "service_id" {
  description = "ECS Service ID"
  value       = var.create_service ? module.ecs_service.service_id : null
}

output "service_arn" {
  description = "ECS Service ARN"
  value       = var.create_service ? module.ecs_service.service_arn : null
}

output "service_name" {
  description = "ECS Service Name"
  value       = var.create_service ? module.ecs_service.service_name : null
}

output "task_definition_arn" {
  description = "ECS Task Definition ARN"
  value       = var.create_service ? module.ecs_service.task_definition_arn : null
}

output "task_role_arn" {
  description = "ECS Task Role ARN"
  value       = var.create_service ? module.ecs_service.task_role_arn : null
}

output "execution_role_arn" {
  description = "ECS Execution Role ARN"
  value       = var.create_service ? module.ecs_service.execution_role_arn : null
}