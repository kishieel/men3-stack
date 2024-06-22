output "alb_hostname" {
  value = aws_alb.default.dns_name
}

output "name_servers" {
  value = aws_route53_zone.public.name_servers
}

output "app_backend_deployed_image" {
  value = data.template_file.backend.vars.app_backend_image
}

output "app_frontend_deployed_image" {
  value = data.template_file.frontend.vars.app_frontend_image
}
