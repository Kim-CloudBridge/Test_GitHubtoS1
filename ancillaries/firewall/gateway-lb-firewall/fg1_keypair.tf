resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key" {
  key_name = format("%sx-%s-forti-kp",
    local.nomenclature_1,
    local.firewall_nomenclature,
  )
  public_key = tls_private_key.key.public_key_openssh

  tags = merge(local.tags, {
    "Name" = format("%sx-%s-forti-kp",
      local.nomenclature_1,
      local.firewall_nomenclature,
    ),
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_secretsmanager_secret" "keypair" {
  name = format("%sx-%s-forti-kp",
    local.nomenclature_1,
    local.firewall_nomenclature,
  )
  #   kms_key_id = var.create_this_fci_kms_keys ? module.KMS-secretsmanager[0].key_id : data.aws_kms_key.secretsmanager[0].key_id
  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "keypair" {
  secret_id     = aws_secretsmanager_secret.keypair.id
  secret_string = tls_private_key.key.private_key_pem
}