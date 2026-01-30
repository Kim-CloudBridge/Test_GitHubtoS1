# Application VPC Configuration
# This module sets up a VPC, Security Groups, NLBs and Target Groups for the main applications.
module "app_vpc" {
  source = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/app-vpc?ref=two_private_layer_vpc_v1.0"
  # Client and environment-specific information.
  client_id   = var.client_id
  client_env  = local.client_env
  environment = local.environment
  common      = local.common_prefix_general_service
  # Flags to control the creation of NAT gateways and internet gateways.
  enable_nat_gateway               = false
  create_igw                       = false
  enable_dhcp_options              = true
  dhcp_options_domain_name         = "lscloud.systems"
  dhcp_options_domain_name_servers = ["10.210.124.176", "10.210.124.245"]
  # dhcp_options_domain_name         = data.terraform_remote_state.managed_ad.outputs.managed_ad_dns_name
  # dhcp_options_domain_name_servers = data.terraform_remote_state.managed_ad.outputs.managed_ad_ips
  # Passing global variables to the module and network ACLs
  global_vars        = module.global_vars
  network_app_acls   = local.network_app_acls
  transit_gateway_id = local.transit_gateway_id
  env_domain         = var.env_domain
  tier               = var.tier
}
module "management_security_group" {
  source      = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/security-groups/modules/mgmt-security-group?ref=tier3_v1.0"
  depends_on  = [module.app_vpc]
  app_vpc     = module.app_vpc
  client_env  = local.client_env
  client_id   = var.client_id
  common      = local.common_prefix_general_service
  env_domain  = var.env_domain
  environment = local.environment
  global_vars = module.global_vars
  # @TODO Fix this. I needed to hardcode it like this because security-group refactor only allows tier1, 2 and 3, but for this account
  # the tier is set to tier0
  tier                                    = "tier3"
  management_security_group_egress_rules  = local.management_security_group_egress_rules
  management_security_group_ingress_rules = local.management_security_group_ingress_rules
}
module "aura_security_group" {
  source      = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/security-groups/modules/aura-security-group?ref=tier3_v1.0"
  depends_on  = [module.app_vpc]
  app_vpc     = module.app_vpc
  client_env  = local.client_env
  client_id   = var.client_id
  common      = local.common_prefix_general_service
  env_domain  = var.env_domain
  environment = local.environment
  global_vars = module.global_vars
  # @TODO Fix this. I needed to hardcode it like this because security-group refactor only allows tier1, 2 and 3, but for this account
  # the tier is set to tier0
  tier                                  = "tier3"
  nlb_aura_security_group_ingress_rules = local.nlb_aura_security_group_ingress_rules
  nlb_aura_security_group_egress_rules  = local.nlb_aura_security_group_egress_rules
  aura_security_group_ingress_rules     = local.aura_security_group_ingress_rules
  aura_security_group_egress_rules      = local.aura_security_group_egress_rules
}
module "halo_security_group" {
  source      = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/security-groups/modules/halo-security-group?ref=tier3_v1.0"
  depends_on  = [module.app_vpc]
  app_vpc     = module.app_vpc
  client_env  = local.client_env
  client_id   = var.client_id
  common      = local.common_prefix_general_service
  env_domain  = var.env_domain
  environment = local.environment
  global_vars = module.global_vars
  # @TODO Fix this. I needed to hardcode it like this because security-group refactor only allows tier1, 2 and 3, but for this account
  # the tier is set to tier0
  tier                                  = "tier3"
  nlb_halo_security_group_ingress_rules = local.nlb_halo_security_group_ingress_rules
  nlb_halo_security_group_egress_rules  = local.nlb_halo_security_group_egress_rules
  halo_security_group_ingress_rules     = local.halo_security_group_ingress_rules
  halo_security_group_egress_rules      = local.halo_security_group_egress_rules
}

module "halo_nlb" {
  source                     = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/lb/modules/app-halo-nlb?ref=lb_module_refactor_v1.4"
  app_subnet_ids_array       = module.app_vpc.app_subnet_ids_array
  app_vpc                    = module.app_vpc
  client_env                 = local.client_env
  client_id                  = var.client_id
  common                     = local.common_prefix_general_service
  env_domain                 = var.env_domain
  environment                = local.environment
  global_vars                = module.global_vars
  nlb_halo_security_group_id = module.halo_security_group.nlb_halo_security_group_id
  tier                       = var.tier

  map_tags            = module.global_vars.global.tagging_convention.map_migrate
}

module "aura_nlb" {
  source                     = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/lb/modules/app-aura-nlb?ref=lb_module_refactor_v1.4"
  app_subnet_ids_array       = module.app_vpc.app_subnet_ids_array
  app_vpc                    = module.app_vpc
  client_env                 = local.client_env
  client_id                  = var.client_id
  common                     = local.common_prefix_general_service
  env_domain                 = var.env_domain
  environment                = local.environment
  global_vars                = module.global_vars
  nlb_aura_security_group_id = module.aura_security_group.nlb_aura_security_group_id
  tier                       = var.tier

  map_tags            = module.global_vars.global.tagging_convention.map_migrate
}

# SSH Access using SSM
resource "aws_iam_role" "ssm_role" {
  name = local.ssm_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge({
    Name = local.ssm_role_name
  }, local.tags)
}

# Get Secrets from Secret Manager
resource "aws_iam_policy" "secrets_manager_get_secret_policy" {
  name        = local.secrets_manager_policy_name
  description = "Policy granting access to all secrets from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "secretsmanager:GetSecretValue",
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

# Attachements
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" # AWS Managed Policy for SSM
}
resource "aws_iam_role_policy_attachment" "cloudwatchagent_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentAdminPolicy" # AWS Managed Policy for CloudWatch Agent
}
resource "aws_iam_role_policy_attachment" "ssm_directory_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess" # AWS Managed Policy for SSM Directory Service
}
resource "aws_iam_role_policy_attachment" "secrets_manager_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.secrets_manager_get_secret_policy.arn
}
resource "aws_iam_role_policy_attachment" "s3_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess" # AWS Managed Policy for CloudWatch Agent
}
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = local.ssm_instance_profile_name
  role = aws_iam_role.ssm_role.name
}

module "auto_managed_instances" {
  source = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/auto-managed-instances?ref=reduced_environment_local_v1.0"
  count  = local.environment.managed_instances_start_stop ? 1 : 0

  client_env  = local.client_env
  common      = local.common_prefix_general_service
  environment = local.environment
  global_vars = module.global_vars
  client_id   = var.client_id
  env_domain  = var.env_domain
  tier        = var.tier
}

# 1000T-HALO
module "halo" {
  source                       = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/halo?ref=ad_tag_v1.1"
  depends_on                   = [module.app_vpc]
  client_id                    = var.client_id
  client_env                   = local.client_env
  environment                  = local.environment
  env_domain                   = var.env_domain
  tier                         = var.tier
  common                       = module.global_vars.global.naming_convention.regions[var.region]
  global_vars                  = module.global_vars
  app_subnet_ids_array         = module.app_vpc.app_subnet_ids_array
  halo_security_group_id       = module.halo_security_group.halo_security_group_id
  nlb_halo_target_group_arn    = module.halo_nlb.nlb_halo_target_group_arn
  ssm_instance_profile         = aws_iam_instance_profile.ssm_instance_profile
  management_security_group_id = module.management_security_group.management_security_group_id

  bia_risk            = module.global_vars.global.tagging_convention.bia_risk.CRITICAL
  cia_risk            = module.global_vars.global.tagging_convention.cia_risk.HIGH
  data_classification = module.global_vars.global.tagging_convention.data_classification.RESTRICTED

  map_tags            = module.global_vars.global.tagging_convention.map_migrate
}

# Aura
# 1000T-HALO
# This module sets up the Aura on the APP VPC.
module "aura" {
  source               = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/aura?ref=ad_tag_v1.1"
  depends_on           = [module.app_vpc]
  client_id            = var.client_id
  client_env           = local.client_env
  environment          = local.environment
  env_domain           = var.env_domain
  tier                 = var.tier
  common               = module.global_vars.global.naming_convention.regions[var.region]
  global_vars          = module.global_vars
  app_subnet_ids_array = module.app_vpc.app_subnet_ids_array
  ssm_instance_profile = aws_iam_instance_profile.ssm_instance_profile

  aura_security_group_id = module.aura_security_group.aura_security_group_id

  nlb_aura_target_group_arn    = module.aura_nlb.nlb_aura_target_group_arn
  management_security_group_id = module.management_security_group.management_security_group_id

  bia_risk            = module.global_vars.global.tagging_convention.bia_risk.CRITICAL
  cia_risk            = module.global_vars.global.tagging_convention.cia_risk.HIGH
  data_classification = module.global_vars.global.tagging_convention.data_classification.RESTRICTED

  map_tags            = module.global_vars.global.tagging_convention.map_migrate
}

module "gateway_vpc_fl" {
  source                       = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/vpc-flow-logs?ref=main"
  depends_on                   = [module.app_vpc]
  count                        = length(local.client_vpc_ids)
  vpc_id                       = local.client_vpc_ids[count.index]
  s3_destination_arn           = data.terraform_remote_state.central_vpc_flow_logs.outputs.central_vpc_fl_bucket_arn
  create_local_flow_logs_store = true
  traffic_type                 = "ALL"

  tags = local.vpc_fl_tags
}