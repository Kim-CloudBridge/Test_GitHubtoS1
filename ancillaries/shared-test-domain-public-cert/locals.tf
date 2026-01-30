locals {
  dme_apikey = jsondecode(data.aws_secretsmanager_secret_version.dme_secret.secret_string)["apikey"]
  dme_secretkey = jsondecode(data.aws_secretsmanager_secret_version.dme_secret.secret_string)["secretkey"]

  client_acm_cert_names = [
    "nlfactoringauratest1.lendscape.cloud",
    "nlfactoringhalotest1.lendscape.cloud",
  ]

  client_acm_validation = [
    for clients, attrib in aws_acm_certificate.this : one(attrib.domain_validation_options)
  ]

  tags = merge(module.global_vars.global.tags, {
    "Service"       = module.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Product"       = module.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Component"     = "${module.global_vars.global.tagging_convention.service_tag.LENDSCAPE}-DMZ",
    "Domain"        = "TEST"
  })
}