terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../../vpc"

  name = "basic-ecs-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = "dev"
    Project     = "basic-ecs-example"
  }
}

module "ecs" {
  source = "../../../ecs"

  cluster_name = "basic-ecs-cluster"
  service_name = "basic-web-service"

  task_cpu    = 256
  task_memory = 512

  container_definitions = {
    family = "basic-web-service"
    container_definitions = jsonencode([
      {
        name  = "nginx"
        image = "nginx:latest"
        portMappings = [
          {
            containerPort = 80
            protocol      = "tcp"
          }
        ]
        essential = true
      }
    ])
  }

  desired_count = 1
  launch_type   = "FARGATE"

  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [aws_security_group.ecs_sg.id]

  tags = {
    Environment = "dev"
    Project     = "basic-ecs-example"
    Purpose     = "web-service"
  }
}

resource "aws_security_group" "ecs_sg" {
  name        = "basic-ecs-sg"
  description = "Security group for ECS service"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Environment = "dev"
    Project     = "basic-ecs-example"
    Purpose     = "ecs-sg"
  }
}

