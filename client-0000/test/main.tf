# This module imports global variables that are utilized across multiple other modules.
module "global_vars" {
  source = "../../tf-global"
}

# IAM Roles
module "iam" {
  source      = "../../modules/iam"
  environment = local.environment
  client_env  = local.client_env
  client_id   = local.client_id
  global_vars = module.global_vars
  common      = local.common_prefix_general_service
  env_domain  = local.domain
  tier        = local.tier
}

# DMZ VPC Configuration
# This module sets up a VPC for the DMZ (Demilitarized Zone) to achieve physical and logical subnetwork containing
# the external-facing services
module "dmz_vpc" {
  source = "../../modules/dmz-vpc"
  # Client and environment-specific information.
  client_id   = local.client_id
  client_env  = local.client_env
  environment = local.environment
  common      = local.common_prefix_general_service
  # Flags to control the creation of NAT gateways and internet gateways.
  enable_nat_gateway               = false
  create_igw                       = true
  enable_dhcp_options              = true
  dhcp_options_domain_name         = data.terraform_remote_state.managed_ad.outputs.managed_ad_dns_name
  dhcp_options_domain_name_servers = data.terraform_remote_state.managed_ad.outputs.managed_ad_ips
  # Passing global variables to the module and network ACLs
  global_vars        = module.global_vars
  network_acls_dmz   = local.network_acls_dmz
  transit_gateway_id = local.transit_gateway_id
  env_domain         = local.domain
  tier               = local.tier
}

# Application VPC Configuration
# This module sets up a VPC for the main applications.
module "app_vpc" {
  depends_on = [module.dmz_vpc]
  source     = "../../modules/app-vpc"
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
  env_domain         = local.domain
  tier               = local.tier
}

# Optional VPC Peering module
# This module sets up a VPC peering connection.
module "vpc_peering" {
  count = local.environment.install_egress_access ? 1 : 0

  depends_on = [module.app_vpc, module.dmz_vpc]
  source     = "../../modules/vpc-peering"

  app_vpc         = module.app_vpc
  dmz_vpc         = module.dmz_vpc
  security_groups = module.security_groups
  environment     = local.environment
}

# Common Security Groups Configuration
# This module creates security groups that can be attached to resources in the DMZ and App VPCs.
module "security_groups" {
  source      = "../../modules/security-groups"
  depends_on  = [module.dmz_vpc, module.app_vpc]
  client_id   = local.client_id
  client_env  = local.client_env
  environment = local.environment
  common      = local.common_prefix_general_service
  global_vars = module.global_vars
  dmz_vpc     = module.dmz_vpc
  app_vpc     = module.app_vpc
  # Security group extensions
  alb_security_group_ingress_rules        = local.alb_security_group_ingress_rules
  alb_security_group_egress_rules         = local.alb_security_group_egress_rules
  nginx_security_group_ingress_rules      = local.nginx_security_group_ingress_rules
  nginx_security_group_egress_rules       = local.nginx_security_group_egress_rules
  nlb_halo_security_group_ingress_rules   = local.nlb_halo_security_group_ingress_rules
  nlb_halo_security_group_egress_rules    = local.nlb_halo_security_group_egress_rules
  halo_security_group_ingress_rules       = local.halo_security_group_ingress_rules
  halo_security_group_egress_rules        = local.halo_security_group_egress_rules
  nlb_aura_security_group_ingress_rules   = local.nlb_aura_security_group_ingress_rules
  nlb_aura_security_group_egress_rules    = local.nlb_aura_security_group_egress_rules
  aura_security_group_ingress_rules       = local.aura_security_group_ingress_rules
  aura_security_group_egress_rules        = local.aura_security_group_egress_rules
  nlb_core_security_group_ingress_rules   = local.nlb_core_security_group_ingress_rules
  nlb_core_security_group_egress_rules    = local.nlb_core_security_group_egress_rules
  core_security_group_ingress_rules       = local.core_security_group_ingress_rules
  core_security_group_egress_rules        = local.core_security_group_egress_rules
  mdb_security_group_ingress_rules        = local.mdb_security_group_ingress_rules
  mdb_security_group_egress_rules         = local.mdb_security_group_egress_rules
  rdb_security_group_ingress_rules        = local.rdb_security_group_ingress_rules
  rdb_security_group_egress_rules         = local.rdb_security_group_egress_rules
  core_fsx_security_group_ingress_rules   = local.core_fsx_security_group_ingress_rules
  core_fsx_security_group_egress_rules    = local.core_security_group_egress_rules
  mdb_fsx_security_group_ingress_rules    = local.mdb_fsx_security_group_ingress_rules
  mdb_fsx_security_group_egress_rules     = local.mdb_fsx_security_group_egress_rules
  rdb_fsx_security_group_ingress_rules    = local.rdb_fsx_security_group_ingress_rules
  rdb_fsx_security_group_egress_rules     = local.rdb_fsx_security_group_egress_rules
  management_security_group_ingress_rules = local.management_security_group_ingress_rules
  management_security_group_egress_rules  = local.management_security_group_egress_rules
  ad_cidr                                 = local.ad_cidr
  ew_fw_cidr                              = local.ew_cidr
  env_domain                              = local.domain
  tier                                    = local.tier

  # Requiered for dynamically create the security group for AppStream and allow traffic to Core NLB
  enable_appstream = local.environment.enable_appstream
}

# Target Groups Configuration
# This module sets up target groups for load balancing.
module "target_groups" {
  source      = "../../modules/target-groups"
  depends_on  = [module.dmz_vpc, module.app_vpc]
  app_vpc     = module.app_vpc
  dmz_vpc     = module.dmz_vpc
  client_id   = local.client_id
  client_env  = local.client_env
  environment = local.environment
  common      = local.common_prefix_general_service
  global_vars = module.global_vars
  env_domain  = local.domain
  tier        = local.tier
}

# Load Balancer Configuration
# This module sets up the load balancers.
module "lb" {
  source                     = "../../modules/lb"
  depends_on                 = [module.target_groups]
  client_id                  = local.client_id
  client_env                 = local.client_env
  environment                = local.environment
  common                     = local.common_prefix_general_service
  global_vars                = module.global_vars
  alb_security_group_id      = module.security_groups.alb_security_group_id
  alb_target_group_arn       = module.target_groups.alb_target_group_arn
  public_subnet_ids_array    = module.dmz_vpc.public_subnet_ids_array
  app_subnet_ids_array       = module.app_vpc.app_subnet_ids_array
  nlb_aura_security_group_id = module.security_groups.nlb_aura_security_group_id
  nlb_aura_target_group_arn  = module.target_groups.nlb_aura_target_group_arn
  nlb_core_security_group_id = module.security_groups.nlb_core_security_group_id
  nlb_core_targets_group_arn = module.target_groups.nlb_core_target_groups_arn
  nlb_halo_security_group_id = module.security_groups.nlb_halo_security_group_id
  nlb_halo_target_group_arn  = module.target_groups.nlb_halo_target_group_arn
  env_domain                 = local.domain
  tier                       = local.tier

  map_tags = module.global_vars.global.tagging_convention.map_migrate
}

# Nginx
# This module sets up the nginxs on the DMZ.
# module "nginx" {
#   source                  = "../../modules/nginx"
#   depends_on              = [module.dmz_vpc]
#   client_id               = local.client_id
#   client_env              = local.client_env
#   environment             = local.environment
#   tier                    = local.tier
#   env_domain              = local.domain
#   common                  = local.common_prefix
#   global_vars             = module.global_vars
#   public_subnet_ids_array = module.dmz_vpc.public_subnet_ids_array
#   alb_target_group_arn    = module.target_groups.alb_target_group_arn
#   nginx_security_group_id = module.security_groups.nginx_security_group_id
#   ssm_instance_profile    = module.iam.ssm_instance_profile

#   bia_risk            = module.global_vars.global.tagging_convention.bia_risk.CRITICAL
#   cia_risk            = module.global_vars.global.tagging_convention.cia_risk.HIGH
#   data_classification = module.global_vars.global.tagging_convention.data_classification.RESTRICTED
# }

# Halo
# This module sets up the Halo on the APP VPC.
module "halo" {
  source                       = "../../modules/halo"
  depends_on                   = [module.app_vpc]
  client_id                    = local.client_id
  client_env                   = local.client_env
  environment                  = local.environment
  env_domain                   = local.domain
  tier                         = local.tier
  common                       = local.common_prefix
  global_vars                  = module.global_vars
  app_subnet_ids_array         = module.app_vpc.app_subnet_ids_array
  halo_security_group_id       = module.security_groups.halo_security_group_id
  nlb_halo_target_group_arn    = module.target_groups.nlb_halo_target_group_arn
  ssm_instance_profile         = module.iam.ssm_instance_profile
  management_security_group_id = module.security_groups.management_security_group_id

  bia_risk            = module.global_vars.global.tagging_convention.bia_risk.CRITICAL
  cia_risk            = module.global_vars.global.tagging_convention.cia_risk.HIGH
  data_classification = module.global_vars.global.tagging_convention.data_classification.RESTRICTED

  map_tags = module.global_vars.global.tagging_convention.map_migrate
}

# Aura
# This module sets up the Aura on the APP VPC.
module "aura" {
  source                       = "../../modules/aura"
  depends_on                   = [module.app_vpc]
  client_id                    = local.client_id
  client_env                   = local.client_env
  environment                  = local.environment
  env_domain                   = local.domain
  tier                         = local.tier
  common                       = local.common_prefix
  global_vars                  = module.global_vars
  app_subnet_ids_array         = module.app_vpc.app_subnet_ids_array
  ssm_instance_profile         = module.iam.ssm_instance_profile
  aura_security_group_id       = module.security_groups.aura_security_group_id
  nlb_aura_target_group_arn    = module.target_groups.nlb_aura_target_group_arn
  management_security_group_id = module.security_groups.management_security_group_id
  bia_risk                     = module.global_vars.global.tagging_convention.bia_risk.CRITICAL
  cia_risk                     = module.global_vars.global.tagging_convention.cia_risk.HIGH
  data_classification          = module.global_vars.global.tagging_convention.data_classification.RESTRICTED

  map_tags = module.global_vars.global.tagging_convention.map_migrate
}

# Core
# This module sets up the Core on the APP VPC.
module "core" {
  source                       = "../../modules/core"
  depends_on                   = [module.app_vpc]
  client_id                    = local.client_id
  client_env                   = local.client_env
  environment                  = local.environment
  env_domain                   = local.domain
  tier                         = local.tier
  common                       = local.common_prefix
  global_vars                  = module.global_vars
  app_subnet_ids_array         = module.app_vpc.app_subnet_ids_array
  ssm_instance_profile         = module.iam.ssm_instance_profile
  core_security_group_id       = module.security_groups.core_security_group_id
  nlb_core_target_groups_arn   = module.target_groups.nlb_core_target_groups_arn
  management_security_group_id = module.security_groups.management_security_group_id
  gen_fsx_security_group_id    = module.security_groups.gen_fsx_security_group_id
  core_fsx_security_group_id   = module.security_groups.core_fsx_security_group_id
  directory_id                 = lookup(local.shared_directory_ids, local.account_id)
  fsx_subnet_id                = module.app_vpc.db_subnet_ids_array[0]
  jenkins_sgp                  = "sg-087d54099413bfab5" # @TODO: replace with proper implementation of security group

  bia_risk            = module.global_vars.global.tagging_convention.bia_risk.CRITICAL
  cia_risk            = module.global_vars.global.tagging_convention.cia_risk.HIGH
  data_classification = module.global_vars.global.tagging_convention.data_classification.RESTRICTED

  map_tags = module.global_vars.global.tagging_convention.map_migrate
}

# M-DB
# This module sets up the M-DB on the APP VPC.
module "mdb" {
  source                       = "../../modules/mdb"
  depends_on                   = [module.app_vpc]
  client_id                    = local.client_id
  client_env                   = local.client_env
  environment                  = local.environment
  env_domain                   = local.domain
  tier                         = local.tier
  common                       = local.common_prefix
  global_vars                  = module.global_vars
  db_subnet_ids_array          = module.app_vpc.db_subnet_ids_array
  fsx_subnet_id                = module.app_vpc.db_subnet_ids_array[0]
  ssm_instance_profile         = module.iam.ssm_instance_profile
  mdb_security_group_id        = module.security_groups.mdb_security_group_id
  management_security_group_id = module.security_groups.management_security_group_id
  gen_fsx_security_group_id    = module.security_groups.gen_fsx_security_group_id
  mdb_fsx_security_group_id    = module.security_groups.mdb_fsx_security_group_id
  directory_id                 = lookup(local.shared_directory_ids, local.account_id)
  jenkins_sgp                  = "sg-087d54099413bfab5" # @TODO: replace with proper implementation of security group

  bia_risk            = module.global_vars.global.tagging_convention.bia_risk.CRITICAL
  cia_risk            = module.global_vars.global.tagging_convention.cia_risk.HIGH
  data_classification = module.global_vars.global.tagging_convention.data_classification.RESTRICTED

  map_tags = module.global_vars.global.tagging_convention.map_migrate
}

# R-DB
# This module sets up the R-DB on the APP VPC.
module "rdb" {
  source                       = "../../modules/rdb"
  depends_on                   = [module.app_vpc]
  client_id                    = local.client_id
  client_env                   = local.client_env
  environment                  = local.environment
  env_domain                   = local.domain
  tier                         = local.tier
  common                       = local.common_prefix
  global_vars                  = module.global_vars
  db_subnet_ids_array          = module.app_vpc.db_subnet_ids_array
  ssm_instance_profile         = module.iam.ssm_instance_profile
  rdb_security_group_id        = module.security_groups.rdb_security_group_id
  management_security_group_id = module.security_groups.management_security_group_id
  gen_fsx_security_group_id    = module.security_groups.gen_fsx_security_group_id
  rdb_fsx_security_group_id    = module.security_groups.rdb_fsx_security_group_id
  directory_id                 = lookup(local.shared_directory_ids, local.account_id)
  fsx_subnet_id                = module.app_vpc.db_subnet_ids_array[0]
  jenkins_sgp                  = "sg-087d54099413bfab5" # @TODO: replace with proper implementation of security group


  bia_risk            = module.global_vars.global.tagging_convention.bia_risk.CRITICAL
  cia_risk            = module.global_vars.global.tagging_convention.cia_risk.HIGH
  data_classification = module.global_vars.global.tagging_convention.data_classification.RESTRICTED

  map_tags = module.global_vars.global.tagging_convention.map_migrate
}

##waf
# module "waf" {
#   source                                = "../../modules/waf"
#   depends_on                            = [module.lb]
#   waf_scope                             = local.environment.waf_scope
#   alb_arn                               = module.lb.alb_arn
#   client_env                            = local.client_env
#   common                                = local.common_prefix
#   global_vars                           = module.global_vars
#   enable_cloudwatch_logging             = local.environment.waf_logging
#   enable_cloudwatch_alarm_notifications = true
#   alarm_email_recipient                 = "awswafalerts@lendscape.com"
#   client_id                             = local.client_id
#   env_domain                            = local.domain
#   tier                                  = local.tier
# }

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

module "ssm_domain_join" {
  source       = "../../modules/ssm-domain-join"
  depends_on   = [module.app_vpc]
  directory_id = lookup(local.shared_directory_ids, local.account_id)
}

# This SSM association is used to run the SSM Doc that automatically join all the instances with tag "ADJoined = true"
# into the AD
resource "aws_ssm_association" "ssm_domain_join" {
  name = module.ssm_domain_join.ssm_domain_join_doc_name

  targets {
    key    = "tag:ADJoined"
    values = ["true"]
  }
}

module "auto_managed_instances" {
  source = "../../modules/auto-managed-instances"
  count  = local.environment.managed_instances_start_stop ? 1 : 0

  client_env  = local.client_env
  common      = local.common_prefix
  environment = local.environment
  global_vars = module.global_vars
  client_id   = local.client_id
  env_domain  = local.domain
  tier        = local.tier
}


# @TODO: for clean up. resource removed from state but will retain due to investigation with AWS
# module "fsxn" {
#   source = "../../modules/fsxn"

#   client_env  = local.client_env
#   common      = local.common_prefix
#   environment = local.environment
#   global_vars = module.global_vars
#   client_id   = local.client_id
#   env_domain  = local.domain
#   tier        = local.tier
#   ad_config = {
#     directory_id                           = lookup(local.shared_directory_ids, local.account_id)
#     service_account_password               = jsondecode(data.aws_secretsmanager_secret_version.ad_admin_service_account.secret_string)["awsSeamlessDomainPassword"]
#     service_account_user                   = jsondecode(data.aws_secretsmanager_secret_version.ad_admin_service_account.secret_string)["awsSeamlessDomainUsername"]
#     file_system_administrators_group       = "AWS Delegated FSx Administrators"
#     organizational_unit_distinguished_name = "OU=Computers,OU=lscloud,DC=lscloud,DC=systems"
#   }
#   gen_fsx_security_group_id = module.security_groups.gen_fsx_security_group_id
#   fsx_route_table_ids       = [module.app_vpc.app_route_table.id, module.app_vpc.db_route_table.id]
#   fsx_security_group_id     = module.security_groups.rdb_fsx_security_group_id
#   fsx_subnet_id             = [ module.app_vpc.app_subnet_ids_array[0] ] # temporary
#   fsx_preferred_subnet_id   = module.app_vpc.app_subnet_ids_array[0] # temporary
#   environment_fsxn_config   = local.environment_fsxn_config
# }

module "rdb_fsxn" {
  source                       = "../../modules/rdb"
  depends_on                   = [module.app_vpc]
  client_id                    = local.client_id
  client_env                   = join("", [local.client_id, "x"])
  environment                  = local.environment_x
  env_domain                   = local.domain
  tier                         = local.tier
  common                       = local.common_prefix
  global_vars                  = module.global_vars
  db_subnet_ids_array          = module.app_vpc.app_subnet_ids_array
  ssm_instance_profile         = module.iam.ssm_instance_profile
  rdb_security_group_id        = module.security_groups.rdb_security_group_id
  management_security_group_id = module.security_groups.management_security_group_id
  gen_fsx_security_group_id    = module.security_groups.gen_fsx_security_group_id
  rdb_fsx_security_group_id    = module.security_groups.rdb_fsx_security_group_id
  directory_id                 = lookup(local.shared_directory_ids, local.account_id)
  fsx_subnet_id                = module.app_vpc.app_subnet_ids_array[0]
  jenkins_sgp                  = "sg-087d54099413bfab5" # @TODO: replace with proper implementation of security group


  bia_risk            = module.global_vars.global.tagging_convention.bia_risk.CRITICAL
  cia_risk            = module.global_vars.global.tagging_convention.cia_risk.HIGH
  data_classification = module.global_vars.global.tagging_convention.data_classification.RESTRICTED

  map_tags = module.global_vars.global.tagging_convention.map_migrate
}

# Core
# This module sets up the Core on the APP VPC.
module "core_fsxn" {
  source                       = "../../modules/core"
  depends_on                   = [module.app_vpc]
  client_id                    = local.client_id
  client_env                   = join("", [local.client_id, "x"])
  environment                  = local.environment_x
  env_domain                   = local.domain
  tier                         = local.tier
  common                       = local.common_prefix
  global_vars                  = module.global_vars
  app_subnet_ids_array         = module.app_vpc.app_subnet_ids_array
  ssm_instance_profile         = module.iam.ssm_instance_profile
  core_security_group_id       = module.security_groups.core_security_group_id
  nlb_core_target_groups_arn   = module.target_groups.nlb_core_target_groups_arn
  management_security_group_id = module.security_groups.management_security_group_id
  gen_fsx_security_group_id    = module.security_groups.gen_fsx_security_group_id
  core_fsx_security_group_id   = module.security_groups.core_fsx_security_group_id
  directory_id                 = lookup(local.shared_directory_ids, local.account_id)
  fsx_subnet_id                = module.app_vpc.db_subnet_ids_array[0]
  jenkins_sgp                  = "sg-087d54099413bfab5" # @TODO: replace with proper implementation of security group

  bia_risk            = module.global_vars.global.tagging_convention.bia_risk.CRITICAL
  cia_risk            = module.global_vars.global.tagging_convention.cia_risk.HIGH
  data_classification = module.global_vars.global.tagging_convention.data_classification.RESTRICTED

  map_tags = module.global_vars.global.tagging_convention.map_migrate
}

# M-DB
# This module sets up the M-DB on the APP VPC.
module "mdb_fsxn" {
  source                       = "../../modules/mdb"
  depends_on                   = [module.app_vpc]
  client_id                    = local.client_id
  client_env                   = join("", [local.client_id, "x"])
  environment                  = local.environment_x
  env_domain                   = local.domain
  tier                         = local.tier
  common                       = local.common_prefix
  global_vars                  = module.global_vars
  db_subnet_ids_array          = module.app_vpc.app_subnet_ids_array
  fsx_subnet_id                = module.app_vpc.db_subnet_ids_array[0]
  ssm_instance_profile         = module.iam.ssm_instance_profile
  mdb_security_group_id        = module.security_groups.mdb_security_group_id
  management_security_group_id = module.security_groups.management_security_group_id
  gen_fsx_security_group_id    = module.security_groups.gen_fsx_security_group_id
  mdb_fsx_security_group_id    = module.security_groups.mdb_fsx_security_group_id
  directory_id                 = lookup(local.shared_directory_ids, local.account_id)
  jenkins_sgp                  = "sg-087d54099413bfab5" # @TODO: replace with proper implementation of security group

  bia_risk            = module.global_vars.global.tagging_convention.bia_risk.CRITICAL
  cia_risk            = module.global_vars.global.tagging_convention.cia_risk.HIGH
  data_classification = module.global_vars.global.tagging_convention.data_classification.RESTRICTED

  map_tags = module.global_vars.global.tagging_convention.map_migrate
}

# module "fsxn_multiaz" {
#   source = "../../modules/fsxn"

#   client_env  = join("", [local.client_id, "x"])
#   common      = local.common_prefix
#   environment = local.environment
#   global_vars = module.global_vars
#   client_id   = local.client_id
#   env_domain  = local.domain
#   tier        = local.tier
#   ad_config = {
#     directory_id                           = lookup(local.shared_directory_ids, local.account_id)
#     service_account_password               = jsondecode(data.aws_secretsmanager_secret_version.ad_admin_service_account.secret_string)["awsSeamlessDomainPassword"]
#     service_account_user                   = jsondecode(data.aws_secretsmanager_secret_version.ad_admin_service_account.secret_string)["awsSeamlessDomainUsername"]
#     file_system_administrators_group       = "AWS Delegated FSx Administrators"
#     organizational_unit_distinguished_name = "OU=Computers,OU=lscloud,DC=lscloud,DC=systems"
#   }
#   gen_fsx_security_group_id = module.security_groups.gen_fsx_security_group_id
#   fsx_route_table_ids       = [module.app_vpc.app_route_table.id, module.app_vpc.db_route_table.id]
#   fsx_security_group_id     = module.security_groups.rdb_fsx_security_group_id # module.security_groups.gen_fsx_security_group_id #
#   fsx_subnet_id             = module.app_vpc.app_subnet_ids_array              # temporary
#   fsx_preferred_subnet_id   = module.app_vpc.app_subnet_ids_array[0]           # temporary
#   environment_fsxn_config   = local.environment_fsxn_multiaz_config

#   map_tags = module.global_vars.global.tagging_convention.map_migrate
# }

# Optional AppStream module
# This module sets up a SAAS portal to access AppStream remote desktop
module "appstream_no_idp" {
  count = local.environment.enable_appstream ? 1 : 0

  depends_on = [module.app_vpc, module.security_groups]
  source     = "../../modules/appstream-no-idp"

  app_subnet_ids_array        = module.app_vpc.app_subnet_ids_array
  environment                 = local.environment
  client_env                  = local.client_env
  client_id                   = local.client_id
  global_vars                 = module.global_vars
  common                      = local.common_prefix_general_service
  env_domain                  = local.domain
  tier                        = local.tier
  appstream_security_group_id = module.security_groups.appstream_security_group_id
  appstream_security_group    = module.security_groups.appstream_security_group
}