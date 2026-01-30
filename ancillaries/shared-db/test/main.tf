module "global_vars" {
  source = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//tf-global?ref=main"
}

# IAM Roles
module "iam" {
  source             = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/iam?ref=main"
  client_env         = local.client_env
  client_id          = var.client_id
  global_vars        = module.global_vars
  common             = local.common_prefix_general_service
  env_domain         = var.env_domain
  tier               = var.tier
  require_fsx_policy = true
  allow_assume_role_here = true
  allowed_account_ids = var.assume_role_account_ids
}

## AD tags reference
## 1000T - MDB
module "mdb" {
  source = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/mdb?ref=ad_tag_v1.1"
  # depends_on                   = [module.app_vpc]
  client_id   = var.client_id
  client_env  = local.client_env
  environment = local.environment
  env_domain  = var.env_domain
  tier        = var.tier
  common      = module.global_vars.global.naming_convention.regions[var.region]
  global_vars = module.global_vars

  db_subnet_ids_array          = local.shared_svcs_db_subnets
  mdb_security_group_id        = local.mdb_security_group_id
  management_security_group_id = local.mgmt_security_group_id

  ssm_instance_profile = module.iam.ssm_instance_profile

  bia_risk            = module.global_vars.global.tagging_convention.bia_risk.CRITICAL
  cia_risk            = module.global_vars.global.tagging_convention.cia_risk.HIGH
  data_classification = module.global_vars.global.tagging_convention.data_classification.RESTRICTED
  map_tags            = module.global_vars.global.tagging_convention.map_migrate

  ## FSx section - Optional
  fsx_subnet_id             = ""
  gen_fsx_security_group_id = ""
  mdb_fsx_security_group_id = ""
  directory_id              = ""
  jenkins_sgp               = ""
}

module "rdb" {
  source = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/rdb?ref=ad_tag_v1.1"
  # depends_on                   = [module.app_vpc]
  client_id   = var.client_id
  client_env  = local.client_env
  environment = local.environment
  env_domain  = var.env_domain
  tier        = var.tier
  common      = module.global_vars.global.naming_convention.regions[var.region]
  global_vars = module.global_vars

  db_subnet_ids_array          = local.shared_svcs_db_subnets
  rdb_security_group_id        = local.rdb_security_group_id
  management_security_group_id = local.mgmt_security_group_id

  ssm_instance_profile = module.iam.ssm_instance_profile

  bia_risk            = module.global_vars.global.tagging_convention.bia_risk.CRITICAL
  cia_risk            = module.global_vars.global.tagging_convention.cia_risk.HIGH
  data_classification = module.global_vars.global.tagging_convention.data_classification.RESTRICTED
  map_tags            = module.global_vars.global.tagging_convention.map_migrate

  ## FSx section - Optional
  fsx_subnet_id             = ""
  gen_fsx_security_group_id = ""
  rdb_fsx_security_group_id = ""
  directory_id              = ""
  jenkins_sgp               = ""
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

module "gateway_vpc_fl" {
  source                       = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/vpc-flow-logs?ref=main"
  # depends_on                   = [module.app_vpc]
  count                        = length(local.client_vpc_ids)
  vpc_id                       = local.client_vpc_ids[count.index]
  s3_destination_arn           = data.terraform_remote_state.central_vpc_flow_logs.outputs.central_vpc_fl_bucket_arn
  create_local_flow_logs_store = true
  traffic_type                 = "ALL"

  tags = local.vpc_fl_tags
}

## Do not remove below. For refactoring
## MDB
# resource "aws_instance" "mdb" {
#   count                = var.mdb_instances_count
#   ami                  = var.mdb_ami
#   instance_type        = var.mdb_instance_type
#   iam_instance_profile = module.iam.ssm_instance_profile
#   # user_data            = templatefile("${path.module}/mdb-config/userdata.tpl", { hostname = local.mdb_hostname })

#   network_interface {
#     network_interface_id = element(aws_network_interface.mdb_primary_nic[*].id, count.index)
#     device_index         = 0
#   }

#   root_block_device {
#     tags = merge({
#       # Name       = local.mdb_name[0][count.index]
#       Name       = join("-", [element(local.mdb_name[*], count.index), "0${count.index + 1}"])
#       ReImported = true
#       AutoManage = true
#     }, local.tags)
#   }

#   tags = merge({
#     Name       = join("-", [element(local.mdb_name[*], count.index), "0${count.index + 1}"])
#     ADJoined   = true
#     ReImported = true
#     AutoManage = true
#   }, local.tags)
# }

# resource "aws_network_interface" "mdb_primary_nic" {
#   count             = var.mdb_instances_count
#   subnet_id         = element(local.shared_svcs_db_subnets[*], count.index)
#   security_groups   = [local.mdb_security_group_id, local.mgmt_security_group_id]
#   private_ips_count = var.mdb_number_of_secondary_ips

#   tags = merge({
#     Name = join("-", [element(local.mdb_name[*], count.index), "0${count.index + 1}", "primary-nic"])
#   }, local.tags)
# }

# ## RDB
# resource "aws_instance" "rdb" {
#   count                = var.rdb_instances_count
#   ami                  = var.rdb_ami
#   instance_type        = var.rdb_instance_type
#   iam_instance_profile = module.iam.ssm_instance_profile
#   # user_data            = templatefile("${path.module}/rdb-config/userdata.tpl", { hostname = local.rdb_hostname })

#   network_interface {
#     network_interface_id = element(aws_network_interface.rdb_primary_nic[*].id, count.index)
#     device_index         = 0
#   }

#   root_block_device {
#     tags = merge({
#       # Name       = local.rdb_name[0][count.index]
#       Name       = join("-", [element(local.rdb_name[*], count.index), "0${count.index + 1}"])
#       ReImported = true
#       AutoManage = true
#     }, local.tags)
#   }

#   tags = merge({
#     Name       = join("-", [element(local.rdb_name[*], count.index), "0${count.index + 1}"])
#     ADJoined   = true
#     ReImported = true
#     AutoManage = true
#   }, local.tags)
# }

# resource "aws_network_interface" "rdb_primary_nic" {
#   count             = var.rdb_instances_count
#   subnet_id         = element(local.shared_svcs_db_subnets[*], count.index)
#   security_groups   = [local.rdb_security_group_id, local.mgmt_security_group_id]
#   private_ips_count = var.rdb_number_of_secondary_ips

#   tags = merge({
#     Name = join("-", [element(local.rdb_name[*], count.index), "0${count.index + 1}", "primary-nic"])
#   }, local.tags)
# }