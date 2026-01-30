locals {
  nomenclature_1        = "${var.hms_product_id}-${var.hms_region_id}"
  firewall_nomenclature = "${var.hms_client_id}${var.hms_environment_id}-${var.hms_deployment}"
  azs = [
    "${var.region}a",
    "${var.region}b",
  ]

  firewall_private_subnets = chunklist(var.firewall_private_subnets, 2)
  firewall_public_subnets  = chunklist(var.firewall_public_subnets, 2)

  relay_subnet_aza  = aws_subnet.fw_spv_01[0].id
  relay_subnet_azb  = aws_subnet.fw_spv_01[1].id
  hasync_subnet_aza = aws_subnet.fw_spv_02[0].id
  hasync_subnet_azb = aws_subnet.fw_spv_02[1].id
  mgmt_subnet_aza   = aws_subnet.fw_spb_01[0].id
  mgmt_subnet_azb   = aws_subnet.fw_spb_01[1].id
  data_subnet_aza   = aws_subnet.fw_spb_02[0].id
  data_subnet_azb   = aws_subnet.fw_spb_02[1].id

  transit_gateway_id = data.terraform_remote_state.transit_gateway.outputs.transit_gateway_id

  ami = lookup(jsondecode(data.aws_ssm_parameter.fortigate_ami.value), var.region, "")[var.arch][var.license_type]

  tags = merge(
    module.globalvars.global["tags"],
    {
      "Client Number" = "0000",
      "Service" = module.globalvars.global.tagging_convention.service_tag.FORTIGATE,
      "Product" = module.globalvars.global.tagging_convention.service_tag.FORTIGATE,
      "Component" = "${module.globalvars.global.tagging_convention.service_tag.FORTIGATE}-EW",
      "Tier" = "T0",
      "Environment" = "${module.globalvars.global.tagging_convention.service_tag.FORTIGATE}0000${var.env_domain}",
    }
  )
}