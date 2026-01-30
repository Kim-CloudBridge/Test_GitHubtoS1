resource "aws_ec2_transit_gateway_vpc_attachment" "gateway_vpc" { #fg1011

  transit_gateway_id = data.terraform_remote_state.transit_gateway.outputs.transit_gateway_id
  vpc_id             = aws_vpc.gateway_vpc.id
  subnet_ids         = toset(flatten([for subnet in aws_subnet.spv_01 : subnet.id]))

  dns_support                                     = "enable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  appliance_mode_support = "enable"

  tags = merge(
    local.tags,
    {
      "Name" = format("%sx-%s-tgwat-0%d",
        local.nomenclature_1,
        local.gateway_nomenclature,
        1
      )
    }
  )
}

resource "aws_ec2_transit_gateway_vpc_attachment" "firewall_vpc" { #fg1012

  transit_gateway_id = data.terraform_remote_state.transit_gateway.outputs.transit_gateway_id
  vpc_id             = aws_vpc.firewall_vpc.id
  subnet_ids         = toset(flatten([for subnet in aws_subnet.fw_spv_01 : subnet.id]))

  dns_support                                     = "enable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  appliance_mode_support = "disable"

  tags = merge(
    local.tags,
    {
      "Name" = format("%sx-%s-tgwat-0%d",
        local.nomenclature_1,
        local.firewall_nomenclature,
        1
      )
    }
  )
}