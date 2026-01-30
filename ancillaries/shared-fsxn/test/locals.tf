locals {

  # Calculated attributes
  client_env    = join("", [var.client_id, var.env_suffix])
  common_prefix = join("", [module.global_vars.global.naming_convention.regions[var.region]])
  common_prefix_general_service = join("", [module.global_vars.global.naming_convention.regions[var.region],
  module.global_vars.global.naming_convention.GLOBAL_SERVICE])

  # VPC components
  shared_svcs_vpc        = data.terraform_remote_state.shared_svcs_networking.outputs.shared_svcs_vpc
  shared_svcs_db_subnets = data.terraform_remote_state.shared_svcs_networking.outputs.shared_db_subnets
  db_route_table_id      = data.terraform_remote_state.shared_svcs_networking.outputs.db_route_table_id
  ew_vpc_cidr            = [data.terraform_remote_state.ew_firewall.outputs.firewall_vpc_cidr]

  # Allow inbound SGs
  mdb_security_group_id     = data.terraform_remote_state.shared_svcs_networking.outputs.mdb_security_group_id
  mdb_fsx_security_group_id = data.terraform_remote_state.shared_svcs_networking.outputs.mdb_fsx_security_group_id
  rdb_security_group_id     = data.terraform_remote_state.shared_svcs_networking.outputs.rdb_security_group_id
  rdb_fsx_security_group_id = data.terraform_remote_state.shared_svcs_networking.outputs.rdb_fsx_security_group_id
  mgmt_security_group_id    = data.terraform_remote_state.shared_svcs_networking.outputs.management_security_group_id

  az_placement = var.fsx_deployment_type == "SINGLE_AZ_1" ? substr(data.aws_subnet.fsx_subnet[0].availability_zone, length(data.aws_subnet.fsx_subnet[0].availability_zone) - 1, 1) : "x"

  fsx_name = join("-", [module.global_vars.global.naming_convention.product, join("", [local.common_prefix, local.az_placement]), local.client_env,
    module.global_vars.global.naming_convention.FSXN
  ])

  fsx_svm_name = join("-", [module.global_vars.global.naming_convention.product, join("", [local.common_prefix, local.az_placement]), local.client_env,
    module.global_vars.global.naming_convention.FSXN, module.global_vars.global.naming_convention.SVM
  ])

  fsx_vol_name = join("_", [module.global_vars.global.naming_convention.product, join("", [local.common_prefix, local.az_placement]), local.client_env,
    module.global_vars.global.naming_convention.FSXN, module.global_vars.global.naming_convention.VOLUME
  ])

  hostname = upper(join("-", [local.client_env, module.global_vars.global.naming_convention.FSXN]))

    # Core FSX Security Group
  # Core specific customer and environment ingres and egress rules for Core FSX
  core_fsx_security_group_ingress_rules = [
    {
      type = "ingress"
      from_port = 3260
      to_port = 3260
      protocol = "tcp"
      cidr_blocks = [ module.global_vars.global.lendscape_landing_zone_networks[var.region]["east_west_firewall"] ]
      description = "Allow iSCSI from Network Account"
    }
  ]
  core_fsx_security_group_egress_rules  = [
    {
      type = "egress"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = [ module.global_vars.global.lendscape_landing_zone_networks[var.region]["east_west_firewall"] ]
      description = "Allow SSH to Network Account"
    }
  ]

  environment_fsxn_multiaz_config_tier3 = {
    fsx_deployment_type = var.fsx_deployment_type
    storage_type        = var.fsx_storage_type
    storage_capacity    = var.fsx_storage_capacity
    throughput_capacity = var.fsx_throughput_capacity
    disk_iops_configuration = {
      iops = var.fsx_disk_iops
      mode = "USER_PROVISIONED"
    }
    ontap_volume_type = "RW"

    svm_config = [
      {
        name                       = "core"
        root_volume_security_style = "NTFS"
        volumes = [
          {
            size           = var.core_storage_allocation
            junction_path  = "/vol1"
            security_style = "NTFS"
            tiering_policy = {
              name           = "SNAPSHOT_ONLY"
              cooling_period = 2
            }
          }
        ]
      },
      {
        name                       = "mdb"
        root_volume_security_style = "NTFS"
        volumes = [
          {
            size           = var.mdb_storage_allocation
            junction_path  = "/vol1"
            security_style = "NTFS"
            tiering_policy = {
              name           = "SNAPSHOT_ONLY"
              cooling_period = 2
            }
          }
        ]
      },
      {
        name                       = "rdb"
        root_volume_security_style = "NTFS"
        volumes = [
          {
            size           = var.rdb_storage_allocation
            junction_path  = "/vol1"
            security_style = "NTFS"
            tiering_policy = {
              name           = "SNAPSHOT_ONLY"
              cooling_period = 2
            }
          }
        ]
      }
    ]
  }

  tags = merge(module.global_vars.global.tags, {
    "Client Number" = var.client_id,
    "Service"       = module.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Product"       = module.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Component"     = "${module.global_vars.global.tagging_convention.service_tag.LENDSCAPE}",
    "Tier"          = upper(replace(var.tier, "ier", "")),
    "Environment"   = "${module.global_vars.global.tagging_convention.service_tag.LENDSCAPE}${var.client_id}${var.env_domain}",
    "Domain"        = var.env_domain
  })
}