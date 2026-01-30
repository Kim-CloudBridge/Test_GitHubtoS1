#dmzvpc
module "dmz_vpc" {
  source = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/dmz-vpc?ref=dmz-vpc-2.0-v1.0"
  # Client and environment-specific information.
  client_id   = var.client_id
  client_env  = local.client_env
  environment = local.environment
  common      = local.common_prefix_general_service

  # Flags to control the creation of NAT gateways and internet gateways.
  enable_nat_gateway               = false
  create_igw                       = true
  enable_dhcp_options              = false
  dhcp_options_domain_name         = ""
  dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]
  # Passing global variables to the module and network ACLs
  global_vars        = module.global_vars
  network_acls_dmz   = local.network_acls_dmz
  transit_gateway_id = local.transit_gateway_id
  env_domain         = var.env_domain
  tier               = var.tier
}

module "gateway_vpc_fl" {
  source                       = "../../modules/vpc-flow-logs"
  depends_on                   = [module.dmz_vpc]
  vpc_id                       = module.dmz_vpc.vpc_id
  s3_destination_arn           = data.terraform_remote_state.central_vpc_flow_logs.outputs.central_vpc_fl_bucket_arn
  create_local_flow_logs_store = true
  traffic_type                 = "ALL"

  tags = local.vpc_fl_tags
}

module "dmz_security_group" {
  source     = "../../modules/dmz-security-groups"
  depends_on = [module.dmz_vpc]

  region      = var.region
  global_vars = module.global_vars
  tier        = var.tier
  client_id   = var.client_id
  client_env  = local.client_env
  common      = local.common_prefix_general_service
  dmz_vpc = {
    vpc_id = module.dmz_vpc.vpc_id
  }
  env_domain                         = var.env_domain
  nginx_security_group_ingress_rules = local.nginx_security_group_ingress_rules
  nginx_security_group_egress_rules  = local.nginx_security_group_egress_rules
  alb_security_group_ingress_rules   = local.alb_security_group_ingress_rules
  alb_security_group_egress_rules    = local.alb_security_group_egress_rules
}

module "dmz_alb" {
  source     = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/lb/modules/dmz-alb?ref=lb_module_refactor_v1.3"
  depends_on = [module.dmz_vpc]

  region      = var.region
  global_vars = module.global_vars
  tier        = var.tier
  client_id   = var.client_id
  client_env  = local.client_env
  common      = local.common_prefix_general_service
  env_domain  = var.env_domain
  dmz_vpc = {
    vpc_id = module.dmz_vpc.vpc_id
  }

  alb_security_group_id   = module.dmz_security_group.alb_security_group_id
  public_subnet_ids_array = module.dmz_vpc.public_subnet_ids_array

  public_listener_acm_arn         = data.terraform_remote_state.shared_test_domain_public_certs.outputs.testdmzdefault_lendscape_cloud_arn
  public_listener_client_acm_arns = data.terraform_remote_state.shared_test_domain_public_certs.outputs.client_acm_cert_arns

  map_tags = module.global_vars.global.tagging_convention.map_migrate
}

##waf
module "waf" {
  source                                = "../../modules/waf"
  depends_on                            = [module.dmz_alb]
  waf_scope                             = local.environment.waf_scope
  alb_arn                               = module.dmz_alb.alb_arn
  client_env                            = local.client_env
  common                                = local.common_prefix_general_service
  global_vars                           = module.global_vars
  enable_cloudwatch_logging             = local.environment.waf_logging
  enable_cloudwatch_alarm_notifications = true
  alarm_email_recipient                 = "awswafalerts@lendscape.com"
  client_id                             = var.client_id
  env_domain                            = var.env_domain
  tier                                  = var.tier
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

# Nginx
# This module sets up the nginxs on the DMZ.
module "nginx" {
  source                      = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/nginx?ref=dmz-vpc-2.0_v1.1"
  depends_on                  = [module.dmz_vpc]
  client_id                   = var.client_id
  client_env                  = local.client_env
  environment                 = local.environment
  tier                        = var.tier
  env_domain                  = var.env_domain
  common                      = module.global_vars.global.naming_convention.regions[var.region] # 01
  global_vars                 = module.global_vars
  associate_public_ip_address = true
  nginx_subnet_ids_array      = module.dmz_vpc.public_subnet_ids_array
  alb_target_group_arn        = module.dmz_alb.alb_target_group_arn
  nginx_security_group_id     = module.dmz_security_group.nginx_security_group_id
  ssm_instance_profile        = aws_iam_instance_profile.ssm_instance_profile

  bia_risk            = module.global_vars.global.tagging_convention.bia_risk.CRITICAL
  cia_risk            = module.global_vars.global.tagging_convention.cia_risk.HIGH
  data_classification = module.global_vars.global.tagging_convention.data_classification.RESTRICTED

  map_tags = module.global_vars.global.tagging_convention.map_migrate
}

# @NOTICE: Removes as auto_managed_instances are deployed through Shared WebServer Implem
# module "auto_managed_instances" {
#   source = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/auto-managed-instances?ref=reduced_environment_local_v1.0"
#   count  = local.environment.managed_instances_start_stop ? 1 : 0

#   client_env  = local.client_env
#   common      = local.common_prefix_general_service
#   environment = local.environment
#   global_vars = module.global_vars
#   client_id   = var.client_id
#   env_domain  = var.env_domain
#   tier        = var.tier
# }