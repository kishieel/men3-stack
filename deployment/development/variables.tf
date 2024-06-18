variable "region" {
  type        = string
  description = "AWS region to deploy the resources in."
  default     = "eu-central-1"
}

variable "public_az" {
  type        = string
  description = "Public availability zone to deploy the resources in."
  default     = "eu-central-1a"
}

variable "ami_id" {
  type        = string
  description = "AMI ID to use for the EC2 instances."
  default     = "ami-02da8ff11275b7907"
}

variable "instance_type" {
  type        = string
  description = "Instance type to use for the EC2 instances."
  default     = "t2.micro"
}

variable "allowed_ssh_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks to allow SSH access from."
}

variable "docker_username" {
  type        = string
  description = "Docker username to use for GitHub Container Registry."
}

variable "docker_password" {
  type        = string
  description = "Docker password to use for GitHub Container Registry."
  sensitive   = true
}
