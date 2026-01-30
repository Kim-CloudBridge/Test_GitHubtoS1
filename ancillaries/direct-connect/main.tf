resource "aws_dx_gateway" "network" {
  name = format("%sx-%s-dx-gw-0%d",
    local.nomenclature_1,
    local.nomenclature_2,
    1
  )
  amazon_side_asn = local.DX_GATEWAY_ASN
}

resource "aws_dx_transit_virtual_interface" "primary" {
  connection_id = data.aws_dx_connection.primary.id

  dx_gateway_id = aws_dx_gateway.network.id
  name = format("%sx-%s-transit-vif-0%d",
    local.nomenclature_1,
    local.nomenclature_2,
    1
  )
  vlan             = module.globalvars.global.WAN_CONFIG[var.region].CONNS.primary.vlan
  address_family   = "ipv4"
  customer_address = module.globalvars.global.WAN_CONFIG[var.region].CONNS.primary.customer_address
  bgp_asn          = module.globalvars.global.WAN_CONFIG[var.region].CONNS.primary.bgp_asn
  amazon_address   = module.globalvars.global.WAN_CONFIG[var.region].CONNS.primary.amazon_address
  bgp_auth_key     = module.globalvars.global.WAN_CONFIG[var.region].CONNS.primary.bgp_auth_key

  tags = local.tags
}

resource "aws_dx_transit_virtual_interface" "secondary" {
  connection_id = data.aws_dx_connection.secondary.id

  dx_gateway_id = aws_dx_gateway.network.id
  name = format("%sx-%s-transit-vif-0%d",
    local.nomenclature_1,
    local.nomenclature_2,
    2
  )
  vlan             = module.globalvars.global.WAN_CONFIG[var.region].CONNS.secondary.vlan
  address_family   = "ipv4"
  customer_address = module.globalvars.global.WAN_CONFIG[var.region].CONNS.secondary.customer_address
  bgp_asn          = module.globalvars.global.WAN_CONFIG[var.region].CONNS.secondary.bgp_asn
  amazon_address   = module.globalvars.global.WAN_CONFIG[var.region].CONNS.secondary.amazon_address
  bgp_auth_key     = module.globalvars.global.WAN_CONFIG[var.region].CONNS.secondary.bgp_auth_key

  tags = local.tags
}

resource "aws_dx_gateway_association" "network" {
  dx_gateway_id         = aws_dx_gateway.network.id
  associated_gateway_id = data.terraform_remote_state.transit_gateway.outputs.transit_gateway_id

  allowed_prefixes = [ module.globalvars.global.site_networks[var.region] ]
}

data "aws_ec2_transit_gateway_dx_gateway_attachment" "network" {
  transit_gateway_id = data.terraform_remote_state.transit_gateway.outputs.transit_gateway_id
  dx_gateway_id      = aws_dx_gateway.network.id
}

resource "aws_ec2_tag" "tgw_attachment" {
  resource_id = data.aws_ec2_transit_gateway_dx_gateway_attachment.network.id
  key         = "Name"
  value       = format("%sx-%s-tgwa-dxgw-0%d",
    local.nomenclature_1,
    local.nomenclature_2,
    1
  )
}