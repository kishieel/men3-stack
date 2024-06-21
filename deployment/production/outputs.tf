output "alb_hostname" {
  value = aws_alb.default.dns_name
}

output "name_servers" {
  value = aws_route53_zone.public.name_servers
}
