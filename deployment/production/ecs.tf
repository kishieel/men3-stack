locals {
  app_database_url = var.app_environment == "production" ? "mysql://root:${var.mysql_root_password}@${one(aws_db_instance.default).address}:3306/${var.mysql_database}" : "mysql://root:${var.mysql_root_password}@mysql:3306/${var.mysql_database}"
}

resource "aws_ecs_cluster" "default" {
  name = var.fargate_cluster
}

data "template_file" "backend" {
  template = file("${path.module}/tasks/backend.json.tpl")

  vars = {
    aws_region                      = var.aws_region
    app_backend_image               = var.app_backend_image
    app_backend_log_group           = var.app_backend_log_group
    app_backend_migration_log_group = "${var.app_backend_log_group}-migrate"
    # @fixme: value of this variable can be seen in the dashboard, it should be a secret
    app_database_url                = local.app_database_url
  }
}

resource "aws_ecs_task_definition" "backend" {
  family                   = "backend"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.app_backend_cpu
  memory                   = var.app_backend_memory
  container_definitions    = data.template_file.backend.rendered
}

resource "aws_ecs_service" "backend" {
  name                  = "Backend"
  cluster               = aws_ecs_cluster.default.arn
  task_definition       = aws_ecs_task_definition.backend.arn
  desired_count         = var.app_backend_count
  launch_type           = "FARGATE"
  wait_for_steady_state = !var.first_run

  network_configuration {
    subnets          = aws_subnet.private.*.id
    security_groups  = [aws_security_group.backend.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.backend.arn
    container_name   = "backend"
    container_port   = 3000
  }

  service_connect_configuration {
    enabled   = true
    namespace = aws_service_discovery_private_dns_namespace.default.name

    service {
      discovery_name = "backend"
      port_name      = "http"

      client_alias {
        dns_name = "backend"
        port     = 3000
      }
    }
  }

  depends_on = [
    aws_alb_listener.http,
    aws_iam_role_policy_attachment.ecs_task_execution_attachment,
  ]
}

data "template_file" "frontend" {
  template = file("${path.module}/tasks/frontend.json.tpl")

  vars = {
    aws_region             = var.aws_region
    app_frontend_image     = var.app_frontend_image
    app_frontend_log_group = var.app_frontend_log_group
  }
}

resource "aws_ecs_task_definition" "frontend" {
  family                   = "frontend"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.app_frontend_cpu
  memory                   = var.app_frontend_memory
  container_definitions    = data.template_file.frontend.rendered
}

resource "aws_ecs_service" "frontend" {
  name                  = "Frontend"
  cluster               = aws_ecs_cluster.default.arn
  task_definition       = aws_ecs_task_definition.frontend.arn
  desired_count         = var.app_frontend_count
  launch_type           = "FARGATE"
  wait_for_steady_state = !var.first_run

  network_configuration {
    subnets          = aws_subnet.private.*.id
    security_groups  = [aws_security_group.frontend.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.frontend.arn
    container_name   = "frontend"
    container_port   = 3000
  }

  depends_on = [
    aws_alb_listener.http,
    aws_iam_role_policy_attachment.ecs_task_execution_attachment,
  ]
}

data "template_file" "mysql" {
  count    = var.app_environment == "production" ? 0 : 1
  template = file("${path.module}/tasks/mysql.json.tpl")

  vars = {
    aws_region          = var.aws_region
    mysql_image         = var.mysql_image
    mysql_database      = var.mysql_database
    mysql_username      = var.mysql_username
    mysql_password      = var.mysql_password
    mysql_root_password = var.mysql_root_password
  }
}

resource "aws_ecs_task_definition" "mysql" {
  count                    = var.app_environment == "production" ? 0 : 1
  family                   = "mysql"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.mysql_cpu
  memory                   = var.mysql_memory
  container_definitions    = data.template_file.mysql[0].rendered
}

resource "aws_ecs_service" "mysql" {
  count                 = var.app_environment == "production" ? 0 : 1
  name                  = "MySQL"
  cluster               = aws_ecs_cluster.default.arn
  task_definition       = aws_ecs_task_definition.mysql[0].arn
  desired_count         = 1
  launch_type           = "FARGATE"
  wait_for_steady_state = !var.first_run

  network_configuration {
    subnets          = aws_subnet.private.*.id
    security_groups  = [aws_security_group.mysql.id]
    assign_public_ip = true
  }

  service_connect_configuration {
    enabled   = true
    namespace = aws_service_discovery_private_dns_namespace.default.name

    service {
      discovery_name = "mysql"
      port_name      = "mysql"

      client_alias {
        dns_name = "mysql"
        port     = 3306
      }
    }
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_attachment]
}
