#appvpc
module "db_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name          = local.vpc_tag_name
  cidr          = var.environment.app_vpc.cidr
  azs           = local.azs
  intra_subnets = var.environment.app_vpc.intra_subnets # For transit gateway
  # Private subnets can't be created using the module as it creates a private route table per private subnet,
  # and finding the combination will result in creating a NAT Gateway that is not required or forking the code.
  # They (the private subnets) will have to be created manually in the "Private Subnet section".
  # This module requires receiving inside var.environment.app_vpc two arrays with two subnets each
  # (private_subnets_for_applications and private_subnets_for_dbs)
  enable_nat_gateway               = var.enable_nat_gateway
  create_igw                       = var.create_igw
  manage_default_security_group    = false
  manage_default_route_table       = false
  manage_default_network_acl       = false
  public_dedicated_network_acl     = false
  intra_dedicated_network_acl      = true
  intra_inbound_acl_rules          = var.network_app_acls.intra_inbound
  intra_outbound_acl_rules         = var.network_app_acls.intra_outbound
  enable_dhcp_options              = var.enable_dhcp_options
  dhcp_options_domain_name         = var.dhcp_options_domain_name
  dhcp_options_domain_name_servers = var.dhcp_options_domain_name_servers
  # Tagging section
  intra_subnet_names     = local.intra_subnet_names
  intra_route_table_tags = local.intra_route_table_tags
  intra_acl_tags         = local.intra_acl_tags
}

# DB Subnets, Route Tables, Associations, Routes, ACLs and ACL Rules
#appvpc_dbs
resource "aws_subnet" "db_private_subnets" {
  count = length(var.environment.app_vpc.private_subnets_for_dbs)

  vpc_id               = module.db_vpc.vpc_id
  cidr_block           = var.environment.app_vpc.private_subnets_for_dbs[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null

  tags = {
    Name = local.dbs_subnet_names[count.index]
  }
}
resource "aws_route_table" "db_route_table" {
  vpc_id = module.db_vpc.vpc_id

  tags = local.dbs_route_table_tags
}
resource "aws_route_table_association" "db_route_table_with_AZs" {
  count = length(var.environment.app_vpc.private_subnets_for_dbs)

  subnet_id      = aws_subnet.db_private_subnets[count.index].id
  route_table_id = aws_route_table.db_route_table.id
}
# Database subnet TGW route
resource "aws_route" "db_route_0_0_0_0_0" {
  depends_on             = [module.db_vpc]
  route_table_id         = aws_route_table.db_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.transit_gateway_id # Target is a Transit Gateway
}
resource "aws_network_acl" "db_network_acl" {
  vpc_id     = module.db_vpc.vpc_id
  subnet_ids = aws_subnet.db_private_subnets[*].id

  tags = local.db_acl_tags
}
resource "aws_route" "intra_route_0_0_0_0_0" {
  route_table_id         = module.db_vpc.intra_route_table_ids[0]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.transit_gateway_id
}
resource "aws_network_acl_rule" "db_inbound_acl_rules" {
  count = length(var.network_app_acls.db_inbound) > 0 ? length(var.network_app_acls.db_inbound) : 0

  network_acl_id  = aws_network_acl.db_network_acl.id
  egress          = false
  rule_number     = var.network_app_acls.db_inbound[count.index]["rule_number"]
  rule_action     = var.network_app_acls.db_inbound[count.index]["rule_action"]
  from_port       = lookup(var.network_app_acls.db_inbound[count.index], "from_port", null)
  to_port         = lookup(var.network_app_acls.db_inbound[count.index], "to_port", null)
  icmp_code       = lookup(var.network_app_acls.db_inbound[count.index], "icmp_code", null)
  icmp_type       = lookup(var.network_app_acls.db_inbound[count.index], "icmp_type", null)
  protocol        = var.network_app_acls.db_inbound[count.index]["protocol"]
  cidr_block      = lookup(var.network_app_acls.db_inbound[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.network_app_acls.db_inbound[count.index], "ipv6_cidr_block", null)
}
resource "aws_network_acl_rule" "db_outbound_acl_rules" {
  count = length(var.network_app_acls.db_outbound) > 0 ? length(var.network_app_acls.db_outbound) : 0

  network_acl_id  = aws_network_acl.db_network_acl.id
  egress          = true
  rule_number     = var.network_app_acls.db_outbound[count.index]["rule_number"]
  rule_action     = var.network_app_acls.db_outbound[count.index]["rule_action"]
  from_port       = lookup(var.network_app_acls.db_outbound[count.index], "from_port", null)
  to_port         = lookup(var.network_app_acls.db_outbound[count.index], "to_port", null)
  icmp_code       = lookup(var.network_app_acls.db_outbound[count.index], "icmp_code", null)
  icmp_type       = lookup(var.network_app_acls.db_outbound[count.index], "icmp_type", null)
  protocol        = var.network_app_acls.db_outbound[count.index]["protocol"]
  cidr_block      = lookup(var.network_app_acls.db_outbound[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.network_app_acls.db_outbound[count.index], "ipv6_cidr_block", null)
}
###################
# TGW attachment section
###################
#appvpc_tgw
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach" {
  subnet_ids         = [for subnet in aws_subnet.db_private_subnets : subnet.id]
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = module.db_vpc.vpc_id

  tags = local.tgw_att_tags
}