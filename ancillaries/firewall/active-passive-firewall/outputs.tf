output "firewall_vpc_id" {
  value = aws_vpc.firewall_vpc.id
}

output "firewall_vpc_cidr" {
  value = aws_vpc.firewall_vpc.cidr_block
}

output "firewall_relay_private_subnets" {
  value = aws_subnet.fw_spv_01[*].id
}

output "firewall_hasync_private_subnets" {
  value = aws_subnet.fw_spv_02[*].id
}

output "firewall_mgmt_public_subnets" {
  value = aws_subnet.fw_spb_01[*].id
}

output "firewall_data_public_subnets" {
  value = aws_subnet.fw_spb_02[*].id
}

output "firewall_vpc_tgw_subnets" {
  value = toset(flatten([for subnet in aws_subnet.fw_spv_01 : subnet.id]))
}

output "firewall_tgw_route_table" {
  value = [aws_route_table.fw_spv_01_rtb[*].id]
}

output "tgw_attachment" {
  value = aws_ec2_transit_gateway_vpc_attachment.tgw-att-mgmt.id
}

##############################################################################################################
# Fortigate Outputs
##############################################################################################################

output "FGT_Active_MGMT_Public_IP" {
  value       = aws_eip.eip-mgmt1.public_ip
  description = "Public IP address for the Active FortiGate's MGMT interface"
}

output "FGT_Cluster_Public_IP" {
  value       = aws_eip.eip-shared.public_ip
  description = "Public IP address for the Cluster"
}

output "FGT_Passive_MGMT_Public_IP" {
  value       = aws_eip.eip-mgmt2.public_ip
  description = "Public IP address for the Passive FortiGate's MGMT interface"
}

output "FGT_Username" {
  value       = "admin"
  description = "Default Username for FortiGate Cluster"
}

output "FGT_Password" {
  value       = aws_instance.fgt1.id
  description = "Default Password for FortiGate Cluster"
}