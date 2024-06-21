resource "aws_service_discovery_private_dns_namespace" "default" {
  name = "cluster.local"
  vpc  = aws_vpc.default.id
}

resource "aws_route53_zone" "public" {
  name         = var.app_domain_name
}

resource "aws_acm_certificate" "default" {
  domain_name       = var.app_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.default.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.default.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.default.domain_validation_options)[0].resource_record_type
  zone_id         = aws_route53_zone.public.zone_id
  ttl             = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.default.arn
  validation_record_fqdns = [aws_route53_record.cert.fqdn]
}

resource "aws_route53_record" "app" {
  name    = var.app_domain_name
  type    = "A"
  zone_id = aws_route53_zone.public.zone_id

  alias {
    name                   = aws_alb.default.dns_name
    zone_id                = aws_alb.default.zone_id
    evaluate_target_health = true
  }
}
