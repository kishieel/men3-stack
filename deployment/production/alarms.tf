locals {
  observable_services = [
    aws_ecs_service.backend.name,
    aws_ecs_service.frontend.name,
  ]
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  for_each = toset(local.observable_services)
  alarm_name = "${each.value}-high-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 3
  metric_name = "CPUUtilization"
  namespace = "AWS/ECS"
  period = 60
  statistic = "Average"
  threshold = 80

  dimensions = {
    ClusterName = aws_ecs_cluster.default.name
    ServiceName = each.value
  }
}
