terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "vpc" {
  source = "../../../vpc"

  name = "complete-ec2-vpc"
  cidr = "172.16.0.0/16"

  azs              = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  private_subnets  = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24", "172.16.4.0/24"]
  public_subnets   = ["172.16.101.0/24", "172.16.102.0/24", "172.16.103.0/24", "172.16.104.0/24"]
  database_subnets = ["172.16.201.0/24", "172.16.202.0/24", "172.16.203.0/24", "172.16.204.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true
  enable_vpn_gateway     = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  customer_gateways = {
    "corp-gw" = {
      bgp_asn    = 65000
      ip_address = "203.0.113.1"
    }
  }

  tags = {
    Environment = "production"
    Project     = "complete-ec2-example"
    Owner       = "infrastructure-team"
    CostCenter  = "engineering"
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "complete-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = "production"
    Project     = "complete-ec2-example"
    Purpose     = "ec2-iam-role"
  }
}

resource "aws_iam_role_policy_attachment" "ec2_s3" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ec2_cloudwatch" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "complete-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

module "ec2" {
  source = "../../../ec2"

  name          = "complete-ec2-instance"
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "c5.large"
  key_name      = "production-key"
  monitoring    = true

  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = false

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd php mysql php-mysqlnd
              systemctl start httpd
              systemctl enable httpd
              systemctl enable amazon-cloudwatch-agent
              
              # Create sample PHP application
              cat > /var/www/html/index.php << 'EOL'
              <?php
              echo "<h1>Complete EC2 Instance Application</h1>";
              echo "<p>Hostname: " . gethostname() . "</p>";
              echo "<p>Environment: Production</p>";
              echo "<p>Time: " . date('Y-m-d H:i:s') . "</p>";
              ?>
              EOL
              
              # Install CloudWatch agent configuration
              cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.d/config.json << 'CWEOF'
              {
                "agent": {
                  "metrics_collection_interval": 60
                },
                "metrics": {
                  "append_dimensions": {
                    "InstanceId": "$${aws:InstanceId}"
                  },
                  "metrics_collected": {
                    "mem": {
                      "measurement": [
                        "mem_used_percent"
                      ],
                      "metrics_collection_interval": 60
                    },
                    "cpu": {
                      "measurement": [
                        "cpu_usage_idle",
                        "cpu_usage_iowait",
                        "cpu_usage_user",
                        "cpu_usage_system"
                      ],
                      "metrics_collection_interval": 60,
                      "totalcpu": false
                    }
                  }
                }
              }
              CWEOF
              EOF

  root_block_device = [
    {
      delete_on_termination = true
      encrypted             = true
      iops                  = 5000
      kms_key_id            = null
      volume_size           = 50
      volume_type           = "gp3"
    }
  ]

  ebs_block_device = [
    {
      delete_on_termination = true
      device_name           = "/dev/sdf"
      encrypted             = true
      iops                  = 10000
      kms_key_id            = null
      snapshot_id           = null
      volume_size           = 200
      volume_type           = "gp3"
    },
    {
      delete_on_termination = true
      device_name           = "/dev/sdg"
      encrypted             = true
      iops                  = 2000
      kms_key_id            = null
      snapshot_id           = null
      volume_size           = 100
      volume_type           = "io2"
    }
  ]

  tags = {
    Environment = "production"
    Project     = "complete-ec2-example"
    Purpose     = "web-server"
    Backup      = "hourly"
    Monitoring  = "enhanced"
    Patching    = "automatic"
    Compliance  = "SOC2"
    Owner       = "application-team"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "complete-ec2-sg"
  description = "Security group for complete EC2 instance"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
    description     = "SSH access from bastion"
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    description     = "HTTP access from ALB"
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    description     = "HTTPS access from ALB"
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.rds_sg.id]
    description     = "MySQL access from RDS"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Environment = "production"
    Project     = "complete-ec2-example"
    Purpose     = "web-server-sg"
  }
}

resource "aws_security_group" "bastion_sg" {
  name        = "complete-bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12"]
    description = "SSH access from corporate network"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Environment = "production"
    Project     = "complete-ec2-example"
    Purpose     = "bastion-sg"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "complete-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Environment = "production"
    Project     = "complete-ec2-example"
    Purpose     = "alb-sg"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "complete-rds-sg"
  description = "Security group for RDS database"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
    description     = "MySQL access from EC2 instances"
  }

  tags = {
    Environment = "production"
    Project     = "complete-ec2-example"
    Purpose     = "rds-sg"
  }
}