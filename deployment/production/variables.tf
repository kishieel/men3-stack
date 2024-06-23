variable "aws_access_key" {
  type        = string
  description = "AWS access key."
  nullable    = true
  default     = null
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret key."
  nullable    = true
  default     = null
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy the resources in."
  default     = "eu-central-1"
}

variable "ghcr_username" {
  type        = string
  description = "GitHub Container Registry username."
}

variable "ghcr_password" {
  type        = string
  description = "GitHub Container Registry password."
  sensitive   = true
}

variable "app_environment" {
  type        = string
  description = "Environment to deploy the application in."

  validation {
    condition     = can(regex("^(development|production)$", var.app_environment))
    error_message = "Environment must be one of development, or production."
  }
}

variable "mysql_database" {
  type        = string
  description = "Database name."
  default     = "app"
}

variable "mysql_username" {
  type        = string
  description = "Database username."
  sensitive   = true
}

variable "mysql_password" {
  type        = string
  description = "Database password."
  sensitive   = true
}

variable "mysql_root_password" {
  type        = string
  description = "Database root password."
  sensitive   = true
}

variable "app_backend_image" {
  type        = string
  description = "Docker image to use for the backend."
}

variable "app_backend_log_group" {
  type        = string
  description = "Log group to use for the backend."
  default     = "/ecs/backend"
}

variable "app_backend_log_retention" {
  type        = number
  description = "Log retention in days for the backend."
  default     = 1
}

variable "app_backend_count" {
  type        = number
  description = "Number of backend tasks to run."
  default     = 1
}

variable "app_frontend_image" {
  type        = string
  description = "Docker image to use for the frontend."
}

variable "app_frontend_log_group" {
  type        = string
  description = "Log group to use for the frontend."
  default     = "/ecs/frontend"
}

variable "app_frontend_log_retention" {
  type        = number
  description = "Log retention in days for the frontend."
  default     = 1
}

variable "app_frontend_count" {
  type        = number
  description = "Number of frontend tasks to run."
  default     = 1
}

variable "app_domain_name" {
  type        = string
  description = "Domain name to use for the deployment."
}

variable "fargate_cluster" {
  type        = string
  description = "Fargate cluster name."
}

variable "fargate_cpu" {
  type        = string
  description = "CPU units to use for the Fargate tasks."
  default     = "1024"
}

variable "fargate_memory" {
  type        = string
  description = "Memory to use for the Fargate tasks."
  default     = "2048"
}
