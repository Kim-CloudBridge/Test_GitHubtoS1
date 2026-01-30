locals {
  transit_gateway_id = data.terraform_remote_state.transit_gateway.outputs.transit_gateway_id

  nomenclature_1 = "${module.globalvars.global.naming_convention.product}-${module.globalvars.global.naming_convention.regions[var.region]}"
  nomenclature_2 = "${var.client_id}${var.environment_id}"
  azs = [
    "${var.region}a",
    "${var.region}b",
  ]
  dns_protocols = ["udp", "tcp"]

  tags = merge(
    module.globalvars.global.tags,
    var.common_tags,
    {
      "Client Number" = "0000",
      "Service" = module.globalvars.global.tagging_convention.service_tag.ACTIVEDIRECTORY,
      "Product" = module.globalvars.global.tagging_convention.service_tag.ACTIVEDIRECTORY,
      "Component" = "${module.globalvars.global.tagging_convention.service_tag.SHAREDSERVICES}-AD",
      "Tier" = "T0",
      "Environment" = "${module.globalvars.global.tagging_convention.service_tag.SHAREDSERVICES}0000${var.env_domain}",
    }
  )
}