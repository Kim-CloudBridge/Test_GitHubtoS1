resource "aws_ec2_transit_gateway_route_table" "transit_gateway_rtb" {
  for_each = toset(var.transit_gateway_route_tables)

  transit_gateway_id = var.transit_gateway_id

  tags = merge(
    {
      "Name" = format(
        "%s-%s-tgw-rtb",
        var.transit_gateway_naming_prefix,
        each.value,
      ),
    },
    var.tags,
  )
}