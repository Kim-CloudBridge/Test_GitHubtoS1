
## CICD VPC outputs
output "cicd_app_vpc_tgw_att" {
  value = aws_ec2_transit_gateway_vpc_attachment.tgw_attach.id
}

output "cicd_app_vpc_tgw_subnets" {
  value = local.cicd_vpc.tgw_subnets
}

output "cicd_app_route_table" {
  value = aws_route_table.private_subnet_route_table.id
}

output "cicd_mgmt_sec_group" {
  value = module.security_group.mgmt_sec_grp_id
}

output "cicd_vpc" {
  value = aws_vpc.main.id
}

output "cicd_vpc_subnet_ids" {
  value = aws_subnet.cicd_spv_01[*].id
}