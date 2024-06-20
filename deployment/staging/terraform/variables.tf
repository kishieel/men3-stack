variable "aws_region" {
  type        = string
  description = "AWS region to deploy the resources in."
  default     = "eu-central-1"
}

variable "aws_availability_zone" {
  type        = string
  description = "Public availability zone to deploy the resources in."
  default     = "eu-central-1a"
}

variable "aws_ami_id" {
  type        = string
  description = "AMI ID to use for the EC2 instances."
  default     = "ami-02da8ff11275b7907"
}

variable "aws_instance_type" {
  type        = string
  description = "Instance type to use for the EC2 instances."
  default     = "t2.micro"
}

variable "aws_ssh_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks to allow SSH access from."
  default     = []
}
