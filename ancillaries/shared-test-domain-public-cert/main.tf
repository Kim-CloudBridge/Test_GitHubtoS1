resource "aws_acm_certificate" "testdmzdefault_lendscape_cloud" {
  domain_name       = "testdmzdefault.lendscape.cloud"
  validation_method = "DNS"

  tags = merge(local.tags,
  {
    "Client Number" = "0000",
    "Tier"          = "T0",
    "Environment"   = "${module.global_vars.global.tagging_convention.service_tag.LENDSCAPE}0000TEST",
    "Domain"        = "TEST"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "dme_dns_record" "testdmzdefault_lendscape_cloud" {
  for_each = {
    for dvo in aws_acm_certificate.testdmzdefault_lendscape_cloud.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  domain_id     = "${data.dme_domain.lendscape_cloud.id}"
  name          = trimsuffix(each.value.name, ".lendscape.cloud.")
  type          = each.value.type
  ttl           = "60"
  value         = each.value.record
}

resource "aws_acm_certificate" "this" {
  for_each = toset(local.client_acm_cert_names)
  domain_name       = each.key
  validation_method = "DNS"

  tags = merge(local.tags,
  {
    "Client Number" = "0000",
    "Tier"          = "T0",
    "Environment"   = "${module.global_vars.global.tagging_convention.service_tag.LENDSCAPE}0000TEST",
    "Domain"        = "TEST"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "dme_dns_record" "this" {
  for_each = {
    for dvo in local.client_acm_validation:  dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  domain_id     = "${data.dme_domain.lendscape_cloud.id}"
  name          = trimsuffix(each.value.name, ".lendscape.cloud.")
  type          = each.value.type
  ttl           = "60"
  value         = each.value.record
}