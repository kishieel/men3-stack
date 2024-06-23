resource "aws_secretsmanager_secret" "ghcr_credentials" {
  name = "GHCRCredentials"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "ghcr_credentials" {
  secret_id     = aws_secretsmanager_secret.ghcr_credentials.id
  secret_string = jsonencode({
    username = var.ghcr_username
    password = var.ghcr_password
  })
}
