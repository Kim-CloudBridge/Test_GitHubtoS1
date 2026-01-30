resource "aws_secretsmanager_secret" "managed_ad_secrets" {
  name = "/managed-ad/secrets"
}

resource "aws_secretsmanager_secret_version" "managed_ad_secrets" {
  secret_id     = aws_secretsmanager_secret.managed_ad_secrets.id
  secret_string = var.managed_ad_password
}