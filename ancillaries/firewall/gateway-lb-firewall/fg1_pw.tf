resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "password" {
  name = format("%sx-%s-forti-ns-password",
    local.nomenclature_1,
    local.firewall_nomenclature,
  )
  #   kms_key_id = var.create_this_fci_kms_keys ? module.KMS-secretsmanager[0].key_id : data.aws_kms_key.secretsmanager[0].key_id
  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id     = aws_secretsmanager_secret.password.id
  secret_string = random_password.password.result
}