locals {
  nomenclature_1 = "${module.globalvars.global.naming_convention.product}-${module.globalvars.global.naming_convention.regions[var.region]}"
  nomenclature_2 = "${var.hms_client_id}${var.hms_environment_id}"
  azs = [
    "${var.region}a",
    "${var.region}b",
  ]

  DX_GATEWAY_ASN = module.globalvars.global.WAN_CONFIG[var.region].DX_GATEWAY_ASN

  tags = merge(
    module.globalvars.global.tags,
    var.common_tags
  )
}