locals {
  scalable_services = [
    aws_ecs_service.backend.name,
    aws_ecs_service.frontend.name,
  ]
}

resource "aws_appautoscaling_target" "default" {
  for_each           = toset(local.scalable_services)
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.default.name}/${each.value}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "memory" {
  for_each           = toset(local.scalable_services)
  name               = "${each.value}Memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.default[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.default[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.default[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = 80.0
  }
}

resource "aws_appautoscaling_policy" "cpu" {
  for_each           = toset(local.scalable_services)
  name               = "${each.value}CPU"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.default[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.default[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.default[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 80.0
  }
}
