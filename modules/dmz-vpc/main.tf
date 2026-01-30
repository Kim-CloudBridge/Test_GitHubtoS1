#dmzvpc
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name                             = local.vpc_tag_name
  cidr                             = var.environment.vpc.cidr
  azs                              = local.azs
  intra_subnets                    = var.environment.vpc.intra_subnets
  public_subnets                   = var.environment.vpc.public_subnets
  enable_nat_gateway               = var.enable_nat_gateway
  create_igw                       = var.create_igw
  manage_default_security_group    = false
  manage_default_route_table       = false
  manage_default_network_acl       = false
  public_dedicated_network_acl     = true
  intra_dedicated_network_acl      = true
  public_inbound_acl_rules         = var.network_acls_dmz.public_inbound
  public_outbound_acl_rules        = var.network_acls_dmz.public_outbound
  intra_inbound_acl_rules          = var.network_acls_dmz.intra_inbound
  intra_outbound_acl_rules         = var.network_acls_dmz.intra_outbound
  enable_dhcp_options              = var.enable_dhcp_options
  dhcp_options_domain_name         = var.dhcp_options_domain_name
  dhcp_options_domain_name_servers = var.dhcp_options_domain_name_servers
  # Tagging section
  public_subnet_tags_per_az = local.public_subnet_tags_per_az
  intra_subnet_names        = local.intra_subnet_names
  public_route_table_tags   = local.public_route_table_tags
  intra_route_table_tags    = local.intra_route_table_tags
  igw_tags                  = local.igw_tags
  public_acl_tags           = local.public_acl_tags
  intra_acl_tags            = local.intra_acl_tags
}

# Routes for Transit Gateway for public route table
resource "aws_route" "route_10_210_50_0_24" {
  depends_on             = [module.vpc]
  route_table_id         = module.vpc.public_route_table_ids[0]
  destination_cidr_block = "10.210.0.0/16"
  transit_gateway_id     = var.transit_gateway_id # Target is a Transit Gateway
}
# resource "aws_route" "route_10_210_124_0_22" {
#   depends_on             = [module.vpc]
#   route_table_id         = module.vpc.public_route_table_ids[0]
#   destination_cidr_block = "10.210.124.0/22"
#   transit_gateway_id     = var.transit_gateway_id # Target is a Transit Gateway
# }
resource "aws_route" "public_route_0_0_0_0_0" {
  depends_on             = [module.vpc]
  route_table_id         = module.vpc.public_route_table_ids[0]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc.igw_id
}
# Routes for Transit Gateway for private route table
# resource "aws_route" "private_route_0_0_0_0_0" {
#   depends_on             = [module.vpc]
#   route_table_id         = module.vpc.intra_route_table_ids[0]
#   destination_cidr_block = "0.0.0.0/0"
#   transit_gateway_id     = var.transit_gateway_id # Target is a Transit Gateway
# }

#dmzvpc_tgw
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach" {
  subnet_ids         = [module.vpc.intra_subnets[0], module.vpc.intra_subnets[1]]
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = module.vpc.vpc_id

  tags = local.tgw_att_tags
}