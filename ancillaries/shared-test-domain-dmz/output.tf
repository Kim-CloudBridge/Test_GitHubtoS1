## DMZ VPC outputs
output "test_dmz_vpc_tgw_att" {
  value = module.dmz_vpc.tgw_att
}

output "test_dmz_vpc_tgw_subnets" {
  value = module.dmz_vpc.private_subnet_ids_array
}

output "test_dmz_route_table" {
  value = module.dmz_vpc.intra_route_table_ids
}

output "test_dmz_alb_security_group_id" {
  value = module.dmz_security_group.alb_security_group_id
}

output "test_dmz_nginx_security_group_id" {
  value = module.dmz_security_group.nginx_security_group_id
}