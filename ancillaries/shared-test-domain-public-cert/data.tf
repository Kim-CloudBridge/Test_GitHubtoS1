data "aws_secretsmanager_secret" "dme" {
  name = "ACM/dnsmadeeasy/keys"
}

data "aws_secretsmanager_secret_version" "dme_secret" {
  secret_id = data.aws_secretsmanager_secret.dme.id
}

data "dme_domain" "lendscape_cloud" {
  name        = "lendscape.cloud"
}