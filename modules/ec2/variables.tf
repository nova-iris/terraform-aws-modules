variable "name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key name for the EC2 instance"
  type        = string
  default     = null
}

variable "monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = false
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with the instance"
  type        = list(string)
  default     = null
}

variable "subnet_id" {
  description = "Subnet ID to launch the instance in"
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data to provide when launching the instance"
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Base64-encoded user data to provide when launching the instance"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM instance profile name to associate with the instance"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Associate a public IP address with the instance"
  type        = bool
  default     = false
}

variable "root_block_device" {
  description = "Root block device configuration"
  type = list(object({
    delete_on_termination = bool
    encrypted             = bool
    iops                  = number
    kms_key_id            = string
    volume_size           = number
    volume_type           = string
  }))
  default = []
}


variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
} # Test comment in EC2 module
