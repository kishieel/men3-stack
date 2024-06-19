output "public_ip" {
  value = aws_instance.instance.public_ip
}

output "private_key" {
  value     = tls_private_key.private_key.private_key_pem
  sensitive = true
}

output "public_key" {
  value     = tls_private_key.private_key.public_key_openssh
  sensitive = true
}

output "ghcr_username" {
  value     = var.ghcr_username
  sensitive = true
}

output "ghcr_password" {
  value     = var.ghcr_password
  sensitive = true
}
