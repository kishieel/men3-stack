resource "aws_alb" "default" {
  name            = "LoadBalancer"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.alb.id]
  depends_on      = [
    aws_acm_certificate.default,
    aws_acm_certificate_validation.cert
  ]
}

resource "aws_alb_target_group" "backend" {
  name        = "BackendTargetGroup"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.default.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    unhealthy_threshold = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "5"
    path                = "/api/health/readiness"
  }
}

resource "aws_alb_target_group" "frontend" {
  name        = "FrontendTargetGroup"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.default.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    unhealthy_threshold = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "5"
    path                = "/"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.default.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.default.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.default.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.frontend.arn
  }
}

resource "aws_alb_listener_rule" "backend" {
  listener_arn = aws_alb_listener.https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.backend.arn
  }

  condition {
    path_pattern {
      values = ["/api*"]
    }
  }
}
