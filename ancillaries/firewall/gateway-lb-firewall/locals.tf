locals {
  nomenclature_1        = "${module.globalvars.global.naming_convention.product}-${module.globalvars.global.naming_convention.regions[var.region]}"
  gateway_nomenclature  = "${var.hms_client_id}${var.hms_environment_id}-${var.hms_deployment}gw"
  firewall_nomenclature = "${var.hms_client_id}${var.hms_environment_id}-${var.hms_deployment}"
  azs = [
    "${var.region}a",
    "${var.region}b",
  ]

  firewall_private_subnets = chunklist(var.firewall_private_subnets, 2)
  firewall_public_subnets  = chunklist(var.firewall_public_subnets, 2)
  gateway_private_subnets  = chunklist(var.gateway_private_subnets, 2)

  transit_subnet_aza = aws_subnet.fw_spv_01[0].id
  transit_subnet_azb = aws_subnet.fw_spv_01[1].id
  private_subnet_aza = aws_subnet.fw_spv_02[0].id
  private_subnet_azb = aws_subnet.fw_spv_02[1].id
  public_subnet_aza  = aws_subnet.fw_spb_01[0].id
  public_subnet_azb  = aws_subnet.fw_spb_01[1].id

  site_network   = module.globalvars.global.site_networks[var.region]
  site_network_dmz = module.globalvars.global["site_networks"]["${var.region}-dmz"]
  management_ips = flatten([module.globalvars.global["site_networks"]["eu-dc"], ["3.11.6.235/32"]])

  transit_gateway_id = data.terraform_remote_state.transit_gateway.outputs.transit_gateway_id

  ami = lookup(jsondecode(data.aws_ssm_parameter.fortigate_ami.value), var.region, "")[var.arch][var.licence_type]

  tags = merge(
    module.globalvars.global["tags"],
    {
      "Client Number" = "0000",
      "Service" = module.globalvars.global.tagging_convention.service_tag.FORTIGATE,
      "Product" = module.globalvars.global.tagging_convention.service_tag.FORTIGATE,
      "Component" = "${module.globalvars.global.tagging_convention.service_tag.FORTIGATE}-NS",
      "Tier" = "T0",
      "Environment" = "${module.globalvars.global.tagging_convention.service_tag.FORTIGATE}0000${var.env_domain}",
    }
  )
}