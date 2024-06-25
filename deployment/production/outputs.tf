output "alb_hostname" {
  value = aws_alb.default.dns_name
}

output "route53_name_servers" {
  value = aws_route53_zone.public.name_servers
}

output "app_backend_deployed_image" {
  value = data.template_file.backend.vars.app_backend_image
}

output "app_frontend_deployed_image" {
  value = data.template_file.frontend.vars.app_frontend_image
}

output "ecr_repository_url" {
  value = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
}
