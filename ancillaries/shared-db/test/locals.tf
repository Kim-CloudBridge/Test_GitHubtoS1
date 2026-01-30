locals {
  azs = [
    "${var.region}a",
    "${var.region}b",
  ]

  # Shared Services VPC components
  shared_svcs_vpc           = data.terraform_remote_state.shared_svcs_networking.outputs.shared_svcs_vpc
  shared_svcs_db_subnets    = data.terraform_remote_state.shared_svcs_networking.outputs.shared_db_subnets
  mdb_security_group_id     = data.terraform_remote_state.shared_svcs_networking.outputs.mdb_security_group_id
  mdb_fsx_security_group_id = data.terraform_remote_state.shared_svcs_networking.outputs.mdb_fsx_security_group_id
  rdb_security_group_id     = data.terraform_remote_state.shared_svcs_networking.outputs.rdb_security_group_id
  rdb_fsx_security_group_id = data.terraform_remote_state.shared_svcs_networking.outputs.rdb_fsx_security_group_id
  mgmt_security_group_id    = data.terraform_remote_state.shared_svcs_networking.outputs.management_security_group_id
  client_vpc_ids = [local.shared_svcs_vpc.vpc_id]

  # ssm_instance_profile = module.iam.ssm_instance_profile

  # Calculated attributes
  client_env    = join("", [var.client_id, var.env_suffix])
  common_prefix = join("", [module.global_vars.global.naming_convention.regions[var.region]])
  common_prefix_general_service = join("", [module.global_vars.global.naming_convention.regions[var.region],
  module.global_vars.global.naming_convention.GLOBAL_SERVICE])

  mdb_name = [
    join("-", [module.global_vars.global.naming_convention.product, join("", [local.common_prefix, "a"]), local.client_env,
      module.global_vars.global.naming_convention.MDB,
      module.global_vars.global.naming_convention.EC2
    ]),
    join("-", [module.global_vars.global.naming_convention.product, join("", [local.common_prefix, "b"]), local.client_env,
      module.global_vars.global.naming_convention.MDB,
      module.global_vars.global.naming_convention.EC2
    ])
  ]

  vpc_fl_tags = {
    Name : join("-", [
      module.global_vars.global.naming_convention.product, local.common_prefix_general_service, local.client_env,
      module.global_vars.global.naming_convention.VPC, "FL", "01"
    ])
  }

  mdb_hostname = join("-", [local.client_env, module.global_vars.global.naming_convention.MDB])


  ## RDB section
  rdb_name = [
    join("-", [module.global_vars.global.naming_convention.product, join("", [local.common_prefix, "a"]), local.client_env,
      module.global_vars.global.naming_convention.RDB,
      module.global_vars.global.naming_convention.EC2
    ]),
    join("-", [module.global_vars.global.naming_convention.product, join("", [local.common_prefix, "b"]), local.client_env,
      module.global_vars.global.naming_convention.RDB,
      module.global_vars.global.naming_convention.EC2
    ])
  ]

  rdb_hostname = join("-", [local.client_env, module.global_vars.global.naming_convention.RDB])

  environment = {
    region                       = var.region
    managed_instances_start_stop = true
    dmz = {
      cidr = "172.210.100.0/25"
    }
    vpc = {
      cidr           = "172.210.100.0/25"
      enabled_azs    = ["a", "b"]
      public_subnets = ["172.210.100.96/28", "172.210.100.112/28"]
      intra_subnets  = ["172.210.100.0/28", "172.210.100.16/28"] # transit gateway attachment subnets
    }

    app_vpc = {
      cidr                             = "10.210.100.0/24"
      enabled_azs                      = ["a", "b"]
      private_subnets_for_applications = ["10.210.100.64/26", "10.210.100.128/26"]
      private_subnets_for_dbs          = []
      intra_subnets                    = ["10.210.100.0/28", "10.210.100.16/28"] # transit gateway attachment subnets
    }

    # Lendscape CIDR
    network_account_cidr = "10.210.120.0/22"
    # @TODO: Update tier 3 instance size to t3.large based on SMC.
    # MDB config
    mdb_config = {
      instance_type = {
        "tier1" = "r5.2xlarge"
        "tier2" = "r5.2xlarge"
        "tier3" = "r5.2xlarge"
      }
      # Microsoft Windows Server 2022 Base
      ami = {
        "eu-west-2" = "ami-09161a49a3e45024e"
      }
      ad_tags = {
        "ADJoined"         = "true",
        "ADHostnamePrefix" = upper("${var.client_id}${var.env_suffix}-MDBT3"),
        "ADOrgUnit"        = "OU=client0123Test,OU=lscloud,DC=lscloud,DC=systems"
      }
      number_of_secondary_ips = 2
      create_fsx              = false
    }

    # RDB config
    rdb_config = {
      instance_type = {
        "tier1" = "r5.2xlarge"
        "tier2" = "r5.2xlarge"
        "tier3" = "r5.2xlarge"
      }
      ami = {
        "eu-west-2" = "ami-09161a49a3e45024e"
      }
      ad_tags = {
        "ADJoined"         = "true",
        "ADHostnamePrefix" = upper("${var.client_id}${var.env_suffix}-RDBT3"),
        "ADOrgUnit"        = "OU=client0123Test,OU=lscloud,DC=lscloud,DC=systems"
      }
      number_of_secondary_ips = 2
      create_fsx              = false
    }

    workhours         = "cron(0 7 ? * MON-FRI *)"  # adjusted from 8 to 7 for UTC
    out_of_workhours  = "cron(0 19 ? * MON-FRI *)" # adjusted from 20 to 19 for UTC
    delayed_workhours = "cron(5 7 ? * MON-FRI *)"  # adjusted from 8 to 7 for UTC
  }

  # tagging values
  bia_risk            = module.global_vars.global.tagging_convention.bia_risk.CRITICAL
  cia_risk            = module.global_vars.global.tagging_convention.cia_risk.HIGH
  data_classification = module.global_vars.global.tagging_convention.data_classification.RESTRICTED
  tags = merge(module.global_vars.global.tags, {
    "Client Number"       = var.client_id,
    "Service"             = module.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Product"             = module.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Component"           = "${module.global_vars.global.tagging_convention.service_tag.LENDSCAPE}-${module.global_vars.global.tagging_convention.component_tag.LSMAINDB}",
    "Tier"                = upper(replace(var.tier, "ier", "")),
    "Environment"         = "${module.global_vars.global.tagging_convention.service_tag.LENDSCAPE}${var.client_id}${var.env_domain}",
    "Domain"              = var.env_domain,
    "AssetID"             = "-",
    "BIA Risk"            = local.bia_risk,
    "CIA Risk"            = local.cia_risk,
    "Data Classification" = local.data_classification
  })

}