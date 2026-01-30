output "this_transit_gw_rtb" {
  value = {
    for id, rtb in aws_ec2_transit_gateway_route_table.transit_gateway_rtb : id => rtb.id
  }
}