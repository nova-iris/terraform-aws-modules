<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs_cluster"></a> [ecs\_cluster](#module\_ecs\_cluster) | terraform-aws-modules/ecs/aws | >= 5.0 |
| <a name="module_ecs_service"></a> [ecs\_service](#module\_ecs\_service) | terraform-aws-modules/ecs/aws//modules/service | >= 5.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_configuration"></a> [cluster\_configuration](#input\_cluster\_configuration) | Cluster configuration | `list(map(string))` | `[]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the ECS cluster | `string` | `"ecs-cluster"` | no |
| <a name="input_cluster_settings"></a> [cluster\_settings](#input\_cluster\_settings) | Cluster settings | `list(map(string))` | `[]` | no |
| <a name="input_container_definitions"></a> [container\_definitions](#input\_container\_definitions) | Container definitions for the task | `list(any)` | `[]` | no |
| <a name="input_create_service"></a> [create\_service](#input\_create\_service) | Whether to create ECS service | `bool` | `true` | no |
| <a name="input_deployment_maximum_percent"></a> [deployment\_maximum\_percent](#input\_deployment\_maximum\_percent) | Upper limit on the number of tasks running during a deployment | `number` | `200` | no |
| <a name="input_deployment_minimum_healthy_percent"></a> [deployment\_minimum\_healthy\_percent](#input\_deployment\_minimum\_healthy\_percent) | Lower limit on the number of tasks running during a deployment | `number` | `100` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | Number of instances of the task to place and keep running | `number` | `1` | no |
| <a name="input_enable_execute_command"></a> [enable\_execute\_command](#input\_enable\_execute\_command) | Whether to enable execute command functionality | `bool` | `false` | no |
| <a name="input_fargate_capacity_providers"></a> [fargate\_capacity\_providers](#input\_fargate\_capacity\_providers) | Fargate capacity providers configuration | `map(any)` | `{}` | no |
| <a name="input_launch_type"></a> [launch\_type](#input\_launch\_type) | Launch type for the service | `string` | `"FARGATE"` | no |
| <a name="input_load_balancer"></a> [load\_balancer](#input\_load\_balancer) | Load balancer configuration | `map(any)` | `{}` | no |
| <a name="input_network_configuration"></a> [network\_configuration](#input\_network\_configuration) | Network configuration for the service | `map(any)` | `{}` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the ECS service | `string` | `"ecs-service"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_task_cpu"></a> [task\_cpu](#input\_task\_cpu) | CPU units for the task | `number` | `256` | no |
| <a name="input_task_memory"></a> [task\_memory](#input\_task\_memory) | Memory (MB) for the task | `number` | `512` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | ECS Cluster ARN |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | ECS Cluster ID |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | ECS Cluster Name |
| <a name="output_execution_role_arn"></a> [execution\_role\_arn](#output\_execution\_role\_arn) | ECS Execution Role ARN |
| <a name="output_service_arn"></a> [service\_arn](#output\_service\_arn) | ECS Service ARN |
| <a name="output_service_id"></a> [service\_id](#output\_service\_id) | ECS Service ID |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | ECS Service Name |
| <a name="output_task_definition_arn"></a> [task\_definition\_arn](#output\_task\_definition\_arn) | ECS Task Definition ARN |
| <a name="output_task_role_arn"></a> [task\_role\_arn](#output\_task\_role\_arn) | ECS Task Role ARN |
<!-- END_TF_DOCS -->