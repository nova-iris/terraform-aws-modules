output "id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2_instance.id
}

output "arn" {
  description = "The ARN of the EC2 instance"
  value       = module.ec2_instance.arn
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2_instance.id
}

output "private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = module.ec2_instance.private_ip
}

output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = module.ec2_instance.public_ip
}

output "availability_zone" {
  description = "The availability zone of the EC2 instance"
  value       = module.ec2_instance.availability_zone
}


output "iam_instance_profile_arn" {
  description = "The ARN of the IAM instance profile"
  value       = module.ec2_instance.iam_instance_profile_arn
}

output "iam_instance_profile_id" {
  description = "The ID of the IAM instance profile"
  value       = module.ec2_instance.iam_instance_profile_id
}