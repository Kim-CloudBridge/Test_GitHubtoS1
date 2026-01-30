output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR Block for DMZ VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids_array" {
  description = "An Array with all the IDs of the public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids_array" {
  description = "An Array with all the IDs of the public subnets"
  value       = module.vpc.intra_subnets
}

output "public_route_table_ids" {
  description = "Public route table"
  value       = module.vpc.public_route_table_ids
}

output "intra_route_table_ids" {
  description = "Intra route table"
  value       = module.vpc.intra_route_table_ids
}

# output "module_vpc" {
#   value = module.vpc
# }

output "tgw_att" {
  description = "App VPC transit gateway attachment"
  value       = aws_ec2_transit_gateway_vpc_attachment.tgw_attach.id
}