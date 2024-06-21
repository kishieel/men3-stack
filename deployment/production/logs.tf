resource "aws_cloudwatch_log_group" "backend" {
  name              = var.app_backend_log_group
  retention_in_days = var.app_backend_log_retention
}

resource "aws_cloudwatch_log_group" "backend-migrate" {
  name              = "${var.app_backend_log_group}-migrate"
  retention_in_days = var.app_backend_log_retention
}

resource "aws_cloudwatch_log_group" "frontend" {
  name              = var.app_frontend_log_group
  retention_in_days = var.app_frontend_log_retention
}

resource "aws_cloudwatch_log_group" "mysql" {
  name              = "/ecs/mysql" # @fixme
  retention_in_days = 1
}
