# This module imports global variables that are utilized across multiple other modules.
module "global_vars" {
  source = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//tf-global"
}

# IAM Roles
module "iam" {
  source          = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/iam?ref=main"
  environment     = local.environment
  client_env      = local.client_env
  client_id       = local.client_id
  global_vars     = module.global_vars
  common          = local.common_prefix_general_service
  env_domain      = local.env_domain
  tier            = local.tier
  assume_role_arn = local.tier3_db_assume_role_arn
}

# Application VPC Configuration
# This module sets up a VPC for the main applications.
module "app_vpc" {
  source = "../../modules/app-vpc"
  # Client and environment-specific information.
  client_id   = local.client_id
  client_env  = local.client_env
  environment = local.environment
  common      = local.common_prefix_general_service
  # Flags to control the creation of NAT gateways and internet gateways.
  enable_nat_gateway               = false
  create_igw                       = false
  enable_dhcp_options              = true
  dhcp_options_domain_name         = data.terraform_remote_state.managed_ad.outputs.managed_ad_dns_name
  dhcp_options_domain_name_servers = data.terraform_remote_state.managed_ad.outputs.managed_ad_ips
  # Passing global variables to the module and network ACLs
  global_vars        = module.global_vars
  network_app_acls   = local.network_app_acls
  transit_gateway_id = local.transit_gateway_id
  env_domain         = local.env_domain
  tier               = local.tier
}

# Security Groups
module "core_security_group" {
  source                                = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/security-groups/modules/core-security-group?ref=tier3_v1.0"
  app_vpc                               = module.app_vpc
  client_env                            = local.client_env
  client_id                             = local.client_id
  common                                = local.common_prefix_general_service
  env_domain                            = local.env_domain
  environment                           = local.environment
  global_vars                           = module.global_vars
  core_security_group_egress_rules      = local.core_security_group_egress_rules
  core_security_group_ingress_rules     = local.core_security_group_ingress_rules
  tier                                  = local.tier
  nlb_core_security_group_egress_rules  = local.nlb_core_security_group_egress_rules
  nlb_core_security_group_ingress_rules = local.nlb_core_security_group_ingress_rules
  ew_fw_cidr                            = local.ew_cidr
}
module "management_security_group" {
  source                                  = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/security-groups/modules/mgmt-security-group?ref=tier3_v1.0"
  depends_on                              = [module.app_vpc]
  app_vpc                                 = module.app_vpc
  client_env                              = local.client_env
  client_id                               = local.client_id
  common                                  = local.common_prefix_general_service
  env_domain                              = local.env_domain
  environment                             = local.environment
  global_vars                             = module.global_vars
  management_security_group_egress_rules  = local.management_security_group_egress_rules
  management_security_group_ingress_rules = local.management_security_group_ingress_rules
  tier                                    = local.tier
}

# NLB and Target Groups
module "core_nlb" {
  source                     = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/lb/modules/app-core-nlb?ref=lb_module_refactor_v1.1"
  app_subnet_ids_array       = module.app_vpc.app_subnet_ids_array
  app_vpc                    = module.app_vpc
  client_env                 = local.client_env
  client_id                  = local.client_id
  common                     = local.common_prefix_general_service
  env_domain                 = local.env_domain
  environment                = local.environment
  global_vars                = module.global_vars
  nlb_core_security_group_id = module.core_security_group.nlb_core_security_group_id
  tier                       = local.tier

  map_tags            = module.global_vars.global.tagging_convention.map_migrate
}

module "gateway_vpc_fl" {
  source                       = "../../modules/vpc-flow-logs"
  depends_on                   = [module.app_vpc]
  count                        = length(local.client_vpc_ids)
  vpc_id                       = local.client_vpc_ids[count.index]
  s3_destination_arn           = data.terraform_remote_state.central_vpc_flow_logs.outputs.central_vpc_fl_bucket_arn
  create_local_flow_logs_store = true
  traffic_type                 = "ALL"

  tags = local.vpc_fl_tags
}

# @TODO To be deployed by Jasper when AD is working
module "core" {
  source                       = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/core?ref=ad_tag_v1.1"
  depends_on                   = [module.app_vpc]
  client_id                    = local.client_id
  client_env                   = local.client_env
  environment                  = local.environment
  env_domain                   = local.env_domain
  tier                         = local.tier
  common                       = local.common_prefix
  global_vars                  = module.global_vars
  app_subnet_ids_array         = module.app_vpc.app_subnet_ids_array
  ssm_instance_profile         = module.iam.ssm_instance_profile
  core_security_group_id       = module.core_security_group.core_security_group_id
  nlb_core_target_groups_arn   = module.core_nlb.nlb_core_target_groups_arn
  management_security_group_id = module.management_security_group.management_security_group_id

  # directory_id                 = lookup(local.shared_directory_ids, local.account_id)

  # jenkins_sgp                  = "sg-087d54099413bfab5" # @TODO: replace with proper implementation of security group

  bia_risk            = module.global_vars.global.tagging_convention.bia_risk.CRITICAL
  cia_risk            = module.global_vars.global.tagging_convention.cia_risk.HIGH
  data_classification = module.global_vars.global.tagging_convention.data_classification.RESTRICTED

  map_tags            = module.global_vars.global.tagging_convention.map_migrate
}

#module "ssm_domain_join" {
#  source       = "../../modules/ssm-domain-join"
#  depends_on   = [module.app_vpc]
#  directory_id = lookup(local.shared_directory_ids, local.account_id)
#}
#
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
#
module "auto_managed_instances" {
  source = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/auto-managed-instances?ref=reduced_environment_local_v1.0"
  count  = local.environment.managed_instances_start_stop ? 1 : 0

  client_env  = local.client_env
  common      = local.common_prefix_general_service
  environment = local.environment
  global_vars = module.global_vars
  client_id   = local.client_id
  env_domain  = local.env_domain
  tier        = local.tier
}