# output "shared_ad" {
#   value = data.external.get_directory.result.directory_id
# }

## APP VPC outputs
output "shared_svcs_vpc" {
 value = module.app_vpc
}

output "shared_db_subnets" {
 value = module.app_vpc.db_subnet_ids_array
}

output "app_route_table" {
 value = module.app_vpc.app_route_table
}

output "db_route_table_id" {
 value = module.app_vpc.db_route_table[0].id
}

output "mdb_security_group_id" {
 value = module.mdb_security_group.mdb_security_group_id
}

output "mdb_fsx_security_group_id" {
 value = module.mdb_security_group.mdb_fsx_security_group_id
}

output "rdb_security_group_id" {
 value = module.rdb_security_group.rdb_security_group_id
}

output "rdb_fsx_security_group_id" {
 value = module.rdb_security_group.rdb_fsx_security_group_id
}

output "management_security_group_id" {
 value = module.management_security_group.management_security_group_id
}

output "test_db_vpc_tgw_att" {
  value = module.app_vpc.tgw_att
}