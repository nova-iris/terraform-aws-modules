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
  source = "../../.."

  cluster_name = "basic-ecs-cluster"
  service_name  = "basic-web-service"

  task_cpu    = 256
  task_memory = 512

  container_definitions = [
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
  ]

  network_configuration = {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer = {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "nginx"
    container_port   = 80
  }

  desired_count = 1
  launch_type   = "FARGATE"

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

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    description     = "HTTP access from ALB"
  }

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

resource "aws_security_group" "alb_sg" {
  name        = "basic-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

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
    Purpose     = "alb-sg"
  }
}

resource "aws_lb" "ecs_alb" {
  name               = "basic-ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets

  tags = {
    Environment = "dev"
    Project     = "basic-ecs-example"
    Purpose     = "ecs-alb"
  }
}

resource "aws_lb_target_group" "ecs_tg" {
  name        = "basic-ecs-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    path = "/"
  }

  tags = {
    Environment = "dev"
    Project     = "basic-ecs-example"
    Purpose     = "ecs-tg"
  }
}

resource "aws_lb_listener" "ecs_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}