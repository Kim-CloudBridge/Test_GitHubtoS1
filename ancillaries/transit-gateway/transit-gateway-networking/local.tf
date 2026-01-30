locals {
  nomenclature_1         = "${module.globalvars.global.naming_convention.product}-${module.globalvars.global.naming_convention.regions[var.region]}x"
  network_nomenclature_2 = "${var.hms_client_id}${var.hms_environment_id}"
  prod_nomenclature_2    = "${var.hms_client_id}p"
  test_nomenclature_2    = "${var.hms_client_id}t"

  transit_gateway_id = data.terraform_remote_state.transit_gateway.outputs.transit_gateway_id #tgw0101

  tags = merge(
    module.globalvars.global.tags,
    var.common_tags
  )
}