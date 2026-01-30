# output "shared_ad" {
#   value = data.external.get_directory.result.directory_id
# }

## APP VPC outputs
output "client-0000_app_vpc_tgw_att" {
  value = module.app_vpc.tgw_att
}

output "client-0000_app_vpc_tgw_subnets" {
  value = module.app_vpc.app_subnet_ids_array
}

output "client-0000_app_route_table" {
  value = [module.app_vpc.app_route_table.id]
}


## DMZ VPC outputs
output "client-0000_dmz_vpc_tgw_att" {
  value = module.dmz_vpc.tgw_att
}

output "client-0000_dmz_vpc_tgw_subnets" {
  value = module.dmz_vpc.private_subnet_ids_array
}

output "client-0000_dmz_route_table" {
  value = module.dmz_vpc.intra_route_table_ids
}
