output "public_ip" {
  value = aws_eip.elastic_ip.public_ip
}

output "private_key" {
  value     = tls_private_key.private_key.private_key_pem
  sensitive = true
}

output "public_key" {
  value     = tls_private_key.private_key.public_key_openssh
  sensitive = true
}
