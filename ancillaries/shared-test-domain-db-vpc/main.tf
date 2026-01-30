# This module imports global variables that are utilized across multiple other modules.
module "global_vars" {
  source = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//tf-global?ref=main"
}

# IAM Roles
# module "iam" {
#   source      = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/iam?ref=hms_shared_services_vpc"
#   client_env  = local.client_env
#   client_id   = local.client_id
#   global_vars = module.global_vars
#   common      = local.common_prefix_general_service
#   env_domain  = local.domain
#   tier        = local.tier
# }

# Application VPC Configuration
# This module sets up a VPC for the main applications.
module "app_vpc" {
  source = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/app-vpc?ref=two_private_layer_vpc_v1.0"
  # Client and environment-specific information.
  client_id   = local.client_id
  client_env  = local.client_env
  environment = local.environment
  common      = local.common_prefix_general_service
  # Flags to control the creation of NAT gateways and internet gateways.
  enable_nat_gateway               = false
  create_igw                       = false
  enable_dhcp_options              = true
  dhcp_options_domain_name         = data.terraform_remote_state.self_hosted_ad.outputs.ad_dns_name
  dhcp_options_domain_name_servers = data.terraform_remote_state.self_hosted_ad.outputs.ad_dns_ips
  # Passing global variables to the module and network ACLs
  global_vars        = module.global_vars
  network_app_acls   = local.network_app_acls
  transit_gateway_id = local.transit_gateway_id
  env_domain         = local.domain
  tier               = local.tier
}

# Security Groups
module "mdb_security_group" {
  source                               = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/security-groups/modules/mdb-security-group?ref=tier3_v1.0"
  depends_on                           = [module.app_vpc]
  app_vpc                              = module.app_vpc
  client_id                            = local.client_id
  client_env                           = local.client_env
  environment                          = local.environment
  common                               = local.common_prefix_general_service
  global_vars                          = module.global_vars
  env_domain                           = local.domain
  tier                                 = local.tier
  mdb_fsx_security_group_ingress_rules = local.mdb_fsx_security_group_ingress_rules
  mdb_fsx_security_group_egress_rules  = local.mdb_fsx_security_group_egress_rules
  mdb_security_group_ingress_rules     = local.mdb_security_group_ingress_rules
  mdb_security_group_egress_rules      = local.mdb_security_group_egress_rules
  ew_fw_cidr                           = local.ew_cidr
}
module "rdb_security_group" {
  source                               = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/security-groups/modules/rdb-security-group?ref=tier3_v1.0"
  depends_on                           = [module.app_vpc]
  app_vpc                              = module.app_vpc
  client_id                            = local.client_id
  client_env                           = local.client_env
  environment                          = local.environment
  common                               = local.common_prefix_general_service
  global_vars                          = module.global_vars
  env_domain                           = local.domain
  tier                                 = local.tier
  rdb_fsx_security_group_egress_rules  = local.rdb_fsx_security_group_egress_rules
  rdb_fsx_security_group_ingress_rules = local.rdb_fsx_security_group_ingress_rules
  rdb_security_group_egress_rules      = local.rdb_security_group_egress_rules
  rdb_security_group_ingress_rules     = local.rdb_security_group_ingress_rules
  ew_fw_cidr                           = local.ew_cidr
}
module "management_security_group" {
  source                                  = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/security-groups/modules/mgmt-security-group?ref=tier3_v1.0"
  depends_on                              = [module.app_vpc]
  app_vpc                                 = module.app_vpc
  client_env                              = local.client_env
  client_id                               = local.client_id
  common                                  = local.common_prefix_general_service
  env_domain                              = local.domain
  environment                             = local.environment
  global_vars                             = module.global_vars
  management_security_group_egress_rules  = local.management_security_group_egress_rules
  management_security_group_ingress_rules = local.management_security_group_ingress_rules
  tier                                    = local.tier
}

# We can't enable SSM Domain Join until we have the AD Directory connected here
#module "ssm_domain_join" {
#  source       = "../../modules/ssm-domain-join"
#  depends_on   = [module.app_vpc]
#  directory_id = lookup(local.shared_directory_ids, local.account_id)
#}
## This SSM association is used to run the SSM Doc that automatically join all the instances with tag "ADJoined = true"
## into the AD
#resource "aws_ssm_association" "ssm_domain_join" {
#  name = module.ssm_domain_join.ssm_domain_join_doc_name
#
#  targets {
#    key    = "tag:ADJoined"
#    values = ["true"]
#  }
#}
#module "auto_managed_instances" {
#  source = "../../modules/auto-managed-instances"
#  count  = local.environment.managed_instances_start_stop ? 1 : 0
#
#  client_env  = local.client_env
#  common      = local.common_prefix
#  environment = local.environment
#  global_vars = module.global_vars
#  client_id   = local.client_id
#  env_domain  = local.domain
#  tier        = local.tier
#}