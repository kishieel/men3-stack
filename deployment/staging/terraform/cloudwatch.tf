resource "aws_cloudwatch_metric_alarm" "ec2_cpu" {
  alarm_name          = "CPU Utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    InstanceId = aws_instance.instance.id
  }
}

resource "aws_cloudwatch_dashboard" "ec2" {
  dashboard_name = "Staging"
  dashboard_body = jsonencode({
    widgets = [
      {
        type       = "metric",
        x          = 0,
        y          = 6,
        width      = 12,
        height     = 6,
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.instance.id]
          ],
          period = 300,
          stat   = "Average",
          region = var.aws_region,
          title  = "CPU Utilization"
        }
      },
      {
        type       = "metric",
        x          = 23,
        y          = 6,
        width      = 12,
        height     = 6,
        properties = {
          metrics = [
            ["AWS/EC2", "NetworkIn", "InstanceId", aws_instance.instance.id]
          ],
          period = 300,
          stat   = "Average",
          region = var.aws_region,
          title  = "Network In"
        }
      },
      {
        "type" : "alarm",
        "x" : 0,
        "y" : 6,
        "width" : 6,
        "height" : 3,
        "properties" : {
          "title" : "Alarm Status",
          "region" : var.aws_region,
          "alarms" : [aws_cloudwatch_metric_alarm.ec2_cpu.arn]
        }
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "backend" {
  name              = "/aws/ec2/backend"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/aws/ec2/frontend"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "database" {
  name              = "/aws/ec2/database"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "nginx" {
  name              = "/aws/ec2/nginx"
  retention_in_days = 1
}
