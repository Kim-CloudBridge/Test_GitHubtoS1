output "tgw_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.tgw_attach.id
}

output "shared_vpc_tgw_subnets" {
  value = toset(flatten([for subnet in aws_subnet.shared_spv_01 : subnet.id]))
}

output "public_rtb" {
  value = [aws_route_table.public_subnet_route_table.id]
}

output "private_rtb" {
  value = [aws_route_table.private_subnet_route_table.id]
}

output "private_subnets_cidr" {
  value = aws_subnet.shared_spv_01[*].cidr_block
}

output "shared_svcs_vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "ad_dns_ips" {
  value = aws_instance.ad_instance[*].private_ip
}

output "ad_dns_name" {
  value = "lscloud.systems"
}