locals {
  create_tgw = true
  tgw_name = format("%sx-%s-transit-gw-0%d",
    local.nomenclature_1,
    local.nomenclature_2,
    1
  )

  ram_name = format("%sx-%s-tgw-ram-0%d",
    local.nomenclature_1,
    local.nomenclature_2,
    1
  )
  description = ""

}


resource "aws_ec2_transit_gateway" "tgw_01" { #tgw0101
  description = coalesce(local.description, local.tgw_name)

  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  auto_accept_shared_attachments  = "enable"

  tags = merge(
    {
      "Name" = local.tgw_name
    },
    local.tags,
  )
}

resource "aws_ec2_transit_gateway_route_table" "tgw_rtb_default" { #tgw0102
  transit_gateway_id = aws_ec2_transit_gateway.tgw_01.id

  tags = merge(
    {
      "Name" = format("%sx-%s-tgw-default-0%d",
        local.nomenclature_1,
        local.nomenclature_2,
        1
      )
    },
    local.tags,
  )
}

resource "aws_ec2_transit_gateway_route" "tgw_rtb_default_routes" { #tgw0103
  destination_cidr_block = "0.0.0.0/0"
  blackhole              = true

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rtb_default.id
}


##########################
# Resource Access Manager #tgw0104
##########################
resource "aws_ram_resource_share" "this" {
  name                      = coalesce(local.ram_name, local.tgw_name)
  allow_external_principals = true

  tags = merge(
    {
      "Name" = coalesce(local.ram_name, local.tgw_name)
    },
    local.tags,
  )
}

resource "aws_ram_resource_association" "this" {
  resource_arn       = aws_ec2_transit_gateway.tgw_01.arn
  resource_share_arn = aws_ram_resource_share.this.id
}

resource "aws_ram_principal_association" "this" {
  for_each = toset(local.ram_shares_ou)

  principal          = each.value
  resource_share_arn = aws_ram_resource_share.this.arn
}