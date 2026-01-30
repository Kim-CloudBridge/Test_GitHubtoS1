output "gateway_vpc_id" {
  value = aws_vpc.gateway_vpc.id
}

output "gateway_private_subnets" {
  value = concat(
    aws_subnet.spv_01[*].id,
    aws_subnet.spv_02[*].id,
  )
}

output "gateway_spv_01_route_table_ids" {
  value = aws_route_table.spv_01_rtb[*].id
}

output "gateway_spv_02_route_table_ids" {
  value = aws_route_table.spv_02_rtb.id
}

output "gateway_load_balancer_endpoints" {
  value = toset(flatten([for vpce in aws_vpc_endpoint.gwlb_endpoint_fg1 : vpce.id]))
}

output "firewall_vpc_id" {
  value = aws_vpc.firewall_vpc.id
}

output "firewall_vpc_cidr" {
  value = aws_vpc.firewall_vpc.cidr_block
}

output "firewall_private_subnets" {
  value = concat(
    aws_subnet.fw_spv_01[*].id,
    aws_subnet.fw_spv_02[*].id,
  )
}

output "firewall_spv_01_route_table_ids" {
  value = aws_route_table.fw_spv_01_rtb[*].id
}

output "firewall_spv_02_route_table_ids" {
  value = aws_route_table.fw_spv_02_rtb.id
}

output "firewall_gateway_lb" {
  value = aws_lb.gateway_lb.name
}

output "ami" {
  value     = local.ami
  sensitive = true
}

# TGW
output "firewall_vpc_transit_gateway_vpc_attachment" {
  value = aws_ec2_transit_gateway_vpc_attachment.firewall_vpc.id
}

output "gateway_vpc_transit_gateway_vpc_attachment" {
  value = aws_ec2_transit_gateway_vpc_attachment.gateway_vpc.id
}

output "firewall_vpc_tgw_subnets" {
  value = toset(flatten([for subnet in aws_subnet.spv_01 : subnet.id]))
}

output "gateway_vpc_tgw_subnets" {
  value = toset(flatten([for subnet in aws_subnet.fw_spv_01 : subnet.id]))
}

output "firewall_vpc_tgw_subnets_route_table_ids" {
  value = [aws_route_table.fw_spb_01_rtb.id]
}

output "gateway_vpc_tgw_subnets_route_table_ids" {
  value = [aws_route_table.spv_02_rtb.id]
}

output "fg1_gwlb_service" {
  value = aws_vpc_endpoint_service.fg1_gwlb_service.service_name
}