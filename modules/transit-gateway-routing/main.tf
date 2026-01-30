#
# transit gateway route table association
#

data "aws_region" "current" {}

# data "aws_ec2_transit_gateway_route_table" "default" {
#   filter {
#     name   = "default-association-route-table"
#     values = ["true"]
#   }
#   filter {
#     name   = "transit-gateway-id"
#     values = [var.tgw_id]
#   }
# }

# resource "null_resource" "disassociate_default_tgw_rtb" {
#   count = length(var.tgw_routing_details["associated_attachments"])

#   provisioner "local-exec" {
#     on_failure = continue

#     # *nix version
#     command="aws ec2 disassociate-transit-gateway-route-table --transit-gateway-route-table-id ${data.aws_ec2_transit_gateway_route_table.default.id} --transit-gateway-attachment-id ${var.tgw_routing_details["associated_attachments"][count.index]} --region ${data.aws_region.current.name} && sleep 90"

#     # Windows version
#     # command="aws ec2 disassociate-transit-gateway-route-table --transit-gateway-route-table-id ${data.aws_ec2_transit_gateway_route_table.default.id} --transit-gateway-attachment-id ${aws_ec2_transit_gateway_vpc_attachment.this_vpc_attachment[each.key].id} --region ${data.aws_region.current.name} & powershell -nop -c \"& {sleep 90}\""
#   }
# }

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  for_each  = var.tgw_routing_details["associated_attachments"]

  # depends_on = [
  #   null_resource.disassociate_default_tgw_rtb
  # ]
  transit_gateway_attachment_id  = each.value
  transit_gateway_route_table_id = var.tgw_route_table_id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  for_each = var.tgw_routing_details["propagated_attachments"]

  transit_gateway_attachment_id  = each.value
  transit_gateway_route_table_id = var.tgw_route_table_id
}

resource "aws_ec2_transit_gateway_route" "this_rtb_static_routes" {
  for_each = var.tgw_routing_details["static_routes"]

  destination_cidr_block         = each.key
  transit_gateway_attachment_id  = each.value == "blackhole" ? null : each.value
  blackhole                      = each.value == "blackhole" ? true : false
  transit_gateway_route_table_id = var.tgw_route_table_id
}