output "vpc_id" {
  description = "The ID of the APP VPC"
  value       = module.db_vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR Block for DMZ VPC"
  value       = module.db_vpc.vpc_cidr_block
}

#output "app_subnet_ids_array" {
#  description = "An Array with all the IDs of the APP subnets"
#  value       = [for subnet in aws_subnet.application_private_subnets : subnet.id]
#}

output "db_subnet_ids_array" {
  description = "An Array with all the IDs of the DB subnets"
  value       = [for subnet in aws_subnet.db_private_subnets : subnet.id]
}

#output "app_route_table" {
#  description = "Application route table"
#  value       = aws_route_table.application_route_table
#}

output "db_route_table" {
  description = "DB route table"
  value       = aws_route_table.db_route_table
}

output "tgw_att" {
  description = "App VPC transit gateway attachment"
  value       = aws_ec2_transit_gateway_vpc_attachment.tgw_attach.id
}
