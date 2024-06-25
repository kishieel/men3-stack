resource "aws_db_instance" "default" {
  count               = var.app_environment == "production" ? 1 : 0
  instance_class      = "db.t3.medium"
  username            = var.mysql_username
  password            = var.mysql_password
  allocated_storage   = 10
  engine              = "mysql"
  engine_version      = "8.0"
  skip_final_snapshot = false

  vpc_security_group_ids = [aws_security_group.mysql.id]
  db_subnet_group_name   = aws_db_subnet_group.default[0].name

  backup_retention_period      = 7
  backup_window                = "03:00-04:00"
  maintenance_window           = "Mon:04:00-Mon:05:00"
  final_snapshot_identifier    = "db-final-snapshot"
  monitoring_interval          = 60
  monitoring_role_arn          = aws_iam_role.rds_monitoring_role.arn
  performance_insights_enabled = true

  multi_az   = false
  depends_on = [aws_db_subnet_group.default]
}

resource "aws_db_subnet_group" "default" {
  count      = var.app_environment == "production" ? 1 : 0
  subnet_ids = aws_subnet.private.*.id
}
