module "global_vars" {
  source = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//tf-global?ref=main"
}

module "core_fsx_security_group" {
  source                                = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/security-groups/modules/corefsx-security-group?ref=tier3_v1.0"
  app_vpc                               = local.shared_svcs_vpc
  client_id                             = var.client_id
  client_env                            = local.client_env
  environment                           = ""
  common                                = local.common_prefix_general_service
  global_vars                           = module.global_vars
  env_domain                            = var.env_domain
  tier                                  = var.tier
  core_fsx_security_group_ingress_rules = local.core_fsx_security_group_ingress_rules
  core_fsx_security_group_egress_rules  = local.core_fsx_security_group_egress_rules
  ew_fw_cidr                            = local.ew_vpc_cidr
}

module "fsxn_multiaz_tier3" {
  source = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/fsxn?ref=tier3_v1.1"

  client_env  = local.client_env
  common      = local.common_prefix_general_service
  environment = local.environment_fsxn_multiaz_config_tier3
  global_vars = module.global_vars
  client_id   = var.client_id
  env_domain  = var.env_domain
  tier        = var.tier
  ad_config = {
    dns_ips                                = var.ad_dns_ip
    domain_name                            = var.ad_domain_name
    service_account_password               = jsondecode(data.aws_secretsmanager_secret_version.ad_admin_service_account.secret_string)["password"]
    service_account_user                   = jsondecode(data.aws_secretsmanager_secret_version.ad_admin_service_account.secret_string)["username"]
    file_system_administrators_group       = "Domain Admins"
    organizational_unit_distinguished_name = "OU=FSx,OU=lscloud,DC=lscloud,DC=systems"
  }
  security_group_ids      = [local.mdb_fsx_security_group_id, local.rdb_fsx_security_group_id, module.core_fsx_security_group.core_fsx_security_group_id, local.mgmt_security_group_id]
  fsx_route_table_ids     = [local.db_route_table_id]
  fsx_subnet_ids          = [local.shared_svcs_db_subnets[0]] # temporary
  fsx_preferred_subnet_id = local.shared_svcs_db_subnets[0]   # temporary
  environment_fsxn_config = local.environment_fsxn_multiaz_config_tier3

  map_tags            = module.global_vars.global.tagging_convention.map_migrate
}

# #############
# #For New Self-Hosted AD
# ############
# #Need to ad_config values when self-hosted AD is setup 
# #Update this file to import tf state of the new self-hosted AD
# #Backup current SVM volumes then restore on the console
# #Import in terraform the restored volumes to the new SVM

# module "fsxn_multiaz_tier3" {
#   source = "git@github.com:CloudBridgeTechnologies/sow894-lendscape-mobilize.git//modules/fsxn?ref=tier3"

#   client_env  = local.client_env
#   common      = local.common_prefix_general_service
#   environment = local.environment_fsxn_multiaz_config_tier3
#   global_vars = module.global_vars
#   client_id   = var.client_id
#   env_domain  = var.env_domain
#   tier        = var.tier
#   ad_config = {
#     dns_ips                                = var.ad_dns_ip
#     domain_name                            = var.ad_domain_name
#     service_account_password               = jsondecode(data.aws_secretsmanager_secret_version.ad_admin_service_account.secret_string)["password"]
#     service_account_user                   = jsondecode(data.aws_secretsmanager_secret_version.ad_admin_service_account.secret_string)["username"]
#     file_system_administrators_group       = "AWS Delegated FSx Administrators"
#     organizational_unit_distinguished_name = "OU=client0123Test,OU=lscloud,DC=lscloud,DC=systems"
#   }
#   security_group_ids      = [local.mdb_fsx_security_group_id, local.rdb_fsx_security_group_id, module.core_fsx_security_group.core_fsx_security_group_id, local.mgmt_security_group_id]
#   fsx_route_table_ids     = [local.db_route_table_id]
#   fsx_subnet_ids          = [local.shared_svcs_db_subnets[0]] # temporary
#   fsx_preferred_subnet_id = local.shared_svcs_db_subnets[0]   # temporary
#   environment_fsxn_config = local.environment_fsxn_multiaz_config_tier3
#   map_tags            = module.global_vars.global.tagging_convention.map_migrate
# }