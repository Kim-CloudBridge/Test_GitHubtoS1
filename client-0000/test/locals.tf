locals {
  region = "eu-west-2"

  # ACLs
  network_acls_dmz = {
    public_inbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 200
        rule_action = "allow"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 50
        rule_action = "allow"
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_block  = "0.0.0.0/0"
      }
    ]
    public_outbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 32768
        to_port     = 65535
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 50
        rule_action = "allow"
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_block  = "0.0.0.0/0"
      }
    ]
    intra_inbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_block  = "0.0.0.0/0"
      }
    ]
    intra_outbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_block  = "0.0.0.0/0"
      }
    ]
  }
  network_app_acls = {
    application_inbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 0
        to_port     = 0
        protocol    = "-1" # all
        cidr_block  = "0.0.0.0/0"
      }
    ]
    application_outbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 0
        to_port     = 0
        protocol    = "-1" # all
        cidr_block  = "0.0.0.0/0"
      }
    ]
    db_inbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 0
        to_port     = 0
        protocol    = "-1" # all
        cidr_block  = "0.0.0.0/0"
      }
    ]
    db_outbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 0
        to_port     = 0
        protocol    = "-1" # all
        cidr_block  = "0.0.0.0/0"
      }
    ]
    intra_inbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 0
        to_port     = 0
        protocol    = "-1" # all
        cidr_block  = "0.0.0.0/0"
      }
    ]
    intra_outbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 0
        to_port     = 0
        protocol    = "-1" # all
        cidr_block  = "0.0.0.0/0"
      }
    ]
  }

  # ALB Security Group
  # Specific customer and environment ingress and egress rules for ALB
  alb_security_group_ingress_rules = [
    # {
    #   type        = "ingress"
    #   from_port   = 80
    #   to_port     = 80
    #   protocol    = "tcp"
    #   cidr_blocks = ["0.0.0.0/0"]
    #   description = "Allow HTTP traffic from Internet"
    # },
    # {
    #   type        = "ingress"
    #   from_port   = 443
    #   to_port     = 443
    #   protocol    = "tcp"
    #   cidr_blocks = ["0.0.0.0/0"]
    #   description = "Allow HTTPs traffic from Internet"
    # }
  ]
  alb_security_group_egress_rules = []

  # Nginx Security Group
  # Specific customer and environment ingres and egress rules for nginx
  nginx_security_group_ingress_rules = []
  nginx_security_group_egress_rules = []

  # NLB Halo Security Group
  # NLB Halo specific customer and environment ingres and egress rules for NLB Halo
  nlb_halo_security_group_ingress_rules = [
    {
      type        = "ingress"
      from_port   = 8081
      to_port     = 8081
      protocol    = "tcp"
      cidr_blocks = [
        module.global_vars.global.lendscape_landing_zone_networks["${local.region}"]["shared_test_domain_dmz"]
      ]
      description = "Allow access from DMZ"
    },
  ]
  nlb_halo_security_group_egress_rules = []

  # Halo Security Group
  # Halo specific customer and environment ingres and egress rules for Halo
  halo_security_group_ingress_rules = []
  halo_security_group_egress_rules  = []

  # NLB Aura Security Group
  # NLB Aura specific customer and environment ingres and egress rules for NLB Aura
  nlb_aura_security_group_ingress_rules = []
  nlb_aura_security_group_egress_rules  = []

  # Aura Security Group
  # Aura specific customer and environment ingres and egress rules for Aura
  aura_security_group_ingress_rules = []
  aura_security_group_egress_rules  = []

  # NLB Core Security Group
  # NLB Core specific customer and environment ingres and egress rules for NLB Core
  nlb_core_security_group_ingress_rules = []
  nlb_core_security_group_egress_rules  = []

  # Core Security Group
  # Core specific customer and environment ingres and egress rules for Core
  core_security_group_ingress_rules = []
  core_security_group_egress_rules  = []

  # MDB Security Group
  # MDB specific customer and environment ingres and egress rules for MDB
  mdb_security_group_ingress_rules = []
  mdb_security_group_egress_rules  = []

  # RDB Security Group
  # RDB specific customer and environment ingres and egress rules for RDB
  rdb_security_group_ingress_rules = []
  rdb_security_group_egress_rules  = []

  # Core FSX Security Group
  # Core specific customer and environment ingres and egress rules for Core FSX
  core_fsx_security_group_ingress_rules = []
  core_fsx_security_group_egress_rules  = []

  # MDB FSX Security Group
  # MDB specific customer and environment ingres and egress rules for MDB FSX
  mdb_fsx_security_group_ingress_rules = []
  mdb_fsx_security_group_egress_rules  = []

  # RDB FSX Security Group
  # RDB specific customer and environment ingres and egress rules for RDB FSX
  rdb_fsx_security_group_ingress_rules = []
  rdb_fsx_security_group_egress_rules  = []

  # Management Security Group
  # Management specific customer and environment ingres and egress
  management_security_group_ingress_rules = [
    {
      type        = "ingress"
      from_port   = 445
      to_port     = 445
      protocol    = "tcp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "ingress"
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      cidr_blocks = ["10.235.0.0/16"]
      description = "Allow RDP from HPW"
    }
  ]
  management_security_group_egress_rules = [
    {
      type        = "egress"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPs traffic to Internet"
    },
    {
      type        = "egress"
      from_port   = 88
      to_port     = 88
      protocol    = "tcp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "egress"
      from_port   = 135
      to_port     = 135
      protocol    = "tcp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "egress"
      from_port   = 389
      to_port     = 389
      protocol    = "tcp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "egress"
      from_port   = 445
      to_port     = 445
      protocol    = "tcp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "egress"
      from_port   = 464
      to_port     = 464
      protocol    = "tcp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "egress"
      from_port   = 636
      to_port     = 636
      protocol    = "tcp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "egress"
      from_port   = 3268
      to_port     = 3269
      protocol    = "tcp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "egress"
      from_port   = 9389
      to_port     = 9389
      protocol    = "tcp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "egress"
      from_port   = 49152
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "egress"
      from_port   = 88
      to_port     = 88
      protocol    = "udp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "egress"
      from_port   = 123
      to_port     = 123
      protocol    = "udp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "egress"
      from_port   = 389
      to_port     = 389
      protocol    = "udp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "egress"
      from_port   = 464
      to_port     = 464
      protocol    = "udp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "egress"
      from_port   = 53
      to_port     = 53
      protocol    = "tcp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "egress"
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "egress"
      from_port   = 445
      to_port     = 445
      protocol    = "tcp"
      cidr_blocks = ["10.230.0.0/16"]
      description = "HPY File Access"
    },
    {
      type        = "egress"
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["10.210.0.0/16"]
      description = "Temporary"
    },
    {
      type        = "egress"
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Ping All"
    },
    {
      type        = "egress"
      from_port   = 25
      to_port     = 25
      protocol    = "tcp"
      cidr_blocks = ["10.240.101.106/32"]
      description = "SMTP Access to HPZ Mail Server"
    }
  ]

  # Definition of the environment
  environment = {
    region                       = local.region
    waf_scope                    = module.global_vars.global.WAF_REGIONAL_SCOPE
    waf_logging                  = true
    install_egress_access        = false
    managed_instances_start_stop = true
    enable_appstream             = false

    vpc = {
      cidr           = "172.210.50.0/25"
      enabled_azs    = ["a", "b"]
      public_subnets = ["172.210.50.96/28", "172.210.50.112/28"]
      intra_subnets  = ["172.210.50.0/28", "172.210.50.16/28"] # transit gateway attachment subnets
    }
    # Inconsistency, depending on the module used, these attributes may or may not be null
    # (not tested for more than two AZs) and behave differently depending on said value
    app_vpc = {
      cidr                             = "10.210.50.0/24"
      enabled_azs                      = ["a", "b"]
      private_subnets_for_applications = ["10.210.50.64/26", "10.210.50.128/26"]
      private_subnets_for_dbs          = ["10.210.50.32/28", "10.210.50.48/28"]
      intra_subnets                    = ["10.210.50.0/28", "10.210.50.16/28"] # transit gateway attachment subnets
    }

    # Lendscape CIDR
    network_account_cidr = "10.210.120.0/22"

    # nginx config
    nginx_config = {
      instance_type = {
        "tier1" = "t3.medium"
        "tier2" = "t2.small"
        "tier3" = "t2.small"
      }
      ami = {
        "eu-west-2" = "ami-0b2d450478e05ad6d"
        "eu-west-1" = "ami-04b9c4c3b112ff925"
      }
    }

    # HALO config
    halo_config = {
      instance_type = {
        "tier1" = "m5.large"
        "tier2" = "t2.small"
        "tier3" = "t2.small"
      }
      # Microsoft Windows Server 2022 Base
      ami = {
        "eu-west-2" = "ami-004128c5853c91821"
        "eu-west-1" = "ami-00c896faf296575ab"
      }
    }

    # AURA config
    aura_config = {
      instance_type = {
        "tier1" = "m5.large"
        "tier2" = "t2.small"
        "tier3" = "t2.small"
      }
      # Microsoft Windows Server 2022 Base
      ami = {
        "eu-west-2" = "ami-004128c5853c91821"
        "eu-west-1" = "ami-00c896faf296575ab"
      }
    }

    # CORE config
    core_config = {
      number_of_secondary_ips = 2
      instance_type = {
        "tier1" = "r5.large"
        "tier2" = "t2.small"
        "tier3" = "t2.small"
      }
      # Microsoft Windows Server 2022 Base
      ami = {
        "eu-west-2" = "ami-0e0f9738ed510a721" # Uses latest custom AMI from Lendscape
        "eu-west-1" = "ami-00c896faf296575ab"
      }
      create_fsx              = false
      fsx_storage_type        = "SSD"
      fsx_storage_capacity    = 300
      fsx_throughput_capacity = 16
      fsx_deployment_type     = "SINGLE_AZ_1"
    }

    # MDB config
    mdb_config = {
      number_of_secondary_ips = 2
      instance_type = {
        "tier1" = "r5.xlarge"
        "tier2" = "t2.small"
        "tier3" = "t2.small"
      }
      # Microsoft Windows Server 2022 with SQL Server 2022 Enterprise
      ami = {
        "eu-west-2" = "ami-0c5db8f6af69d3e91"
        "eu-west-1" = "ami-04ed1f78d22d2b6ee"
      }
      create_fsx              = false
      fsx_storage_type        = "SSD"
      fsx_storage_capacity    = 300
      fsx_throughput_capacity = 16
      fsx_deployment_type     = "SINGLE_AZ_1"
    }

    # RDB config
    rdb_config = {
      number_of_secondary_ips = 2
      instance_type = {
        "tier1" = "r5.xlarge"
        "tier2" = "t2.small"
        "tier3" = "t2.small"
      }
      # Microsoft Windows Server 2022 with SQL Server 2022 Enterprise
      ami = {
        "eu-west-2" = "ami-0c5db8f6af69d3e91"
        "eu-west-1" = "ami-04ed1f78d22d2b6ee"
      }
      create_fsx              = false
      fsx_storage_type        = "SSD"
      fsx_storage_capacity    = 300
      fsx_throughput_capacity = 16
      fsx_deployment_type     = "SINGLE_AZ_1"
    }

    workhours         = "cron(0 7 ? * MON-FRI *)"  # adjusted from 8 to 7 for UTC
    out_of_workhours  = "cron(0 19 ? * MON-FRI *)" # adjusted from 20 to 19 for UTC
    delayed_workhours = "cron(5 7 ? * MON-FRI *)"  # adjusted from 8 to 7 for UTC
  }
  # Tier type (tier1, tier2, tier3)
  tier = "tier1"
  # Client code
  client_id = "0000"
  # Account type: "t = test, p = prod, ss = shared services"
  env_suffix = "t"
  # Managed AD ID
  shared_directory_ids = data.terraform_remote_state.managed_ad.outputs.shared_directory_ids
  account_id           = data.aws_caller_identity.current.account_id
  ad_cidr              = data.terraform_remote_state.self_hosted_ad.outputs.private_subnets_cidr
  ad_vpc_cidr_block    = data.terraform_remote_state.self_hosted_ad.outputs.shared_svcs_vpc_cidr
  ew_cidr              = [data.terraform_remote_state.ew_firewall.outputs.firewall_vpc_cidr]
  # Transit gateway ID
  transit_gateway_id = data.terraform_remote_state.transit_gateway.outputs.transit_gateway_id

  # Calculated attributes
  client_env = join("", [local.client_id, local.env_suffix])
  common_prefix_general_service = join("", [module.global_vars.global.naming_convention.regions[local.environment.region],
  module.global_vars.global.naming_convention.GLOBAL_SERVICE])
  common_prefix = join("", [module.global_vars.global.naming_convention.regions[local.environment.region]])

  vpc_fl_tags = {
    Name : join("-", [
      module.global_vars.global.naming_convention.product, local.common_prefix_general_service, local.client_env,
      module.global_vars.global.naming_convention.VPC, "FL", "01"
    ])
  }

  client_vpc_ids = [module.app_vpc.vpc_id, module.dmz_vpc.vpc_id]

  # Domain: Domains are sub-groups under environments. eg. PROD, TEST, DR
  # Environment on other hand is a concatenation result from Service + Client Number + Domain
  domain = "TEST"

  # bia_risk = module.global_vars.global.tagging_convention.bia_risk.CRITICAL
  # cia_risk = module.global_vars.global.tagging_convention.cia_risk.HIGH
  # data_classification = module.global_vars.global.tagging_convention.data_classification.CONFIDENTIAL

  environment_fsxn_config = {
    fsx_deployment_type = "SINGLE_AZ_1"
    storage_type        = "SSD"
    storage_capacity    = "1024"
    throughput_capacity = "512"
    endpoint_ip_range   = "10.210.50.64/26"
    disk_iops_configuration = {
      iops = "40000"
      mode = "USER_PROVISIONED"
    }
    ontap_volume_type = "RW"
  }

  environment_fsxn_multiaz_config = {
    fsx_deployment_type = "MULTI_AZ_1"
    storage_type        = "SSD"
    storage_capacity    = "11480"
    throughput_capacity = "256"
    # endpoint_ip_range   = "10.210.50.0/24"
    disk_iops_configuration = {
      iops = "40000"
      mode = "USER_PROVISIONED"
    }
    ontap_volume_type = "RW"
    volume_sizes = {
      rdb  = 715264
      mdb  = 10485760
      core = 145408
    }
  }

  environment_singleaz_fsxn_config = {
    fsx_deployment_type = "SINGLE_AZ_1"
    storage_type        = "SSD"
    storage_capacity    = "1024"
    throughput_capacity = "512"
    endpoint_ip_range   = "10.210.50.64/26"
    disk_iops_configuration = {
      iops = "40000"
      mode = "USER_PROVISIONED"
    }
    ontap_volume_type = "RW"
  }

  # TEMPORARY
  environment_x = {
    region                       = local.region
    waf_scope                    = module.global_vars.global.WAF_REGIONAL_SCOPE
    waf_logging                  = true
    install_egress_access        = false
    managed_instances_start_stop = true

    vpc = {
      cidr           = "172.210.50.0/25"
      enabled_azs    = ["a", "b"]
      public_subnets = ["172.210.50.96/28", "172.210.50.112/28"]
      intra_subnets  = ["172.210.50.0/28", "172.210.50.16/28"] # transit gateway attachment subnets
    }
    app_vpc = {
      cidr                             = "10.210.50.0/24"
      enabled_azs                      = ["a", "b"]
      private_subnets_for_applications = ["10.210.50.64/26", "10.210.50.128/26"]
      private_subnets_for_dbs          = ["10.210.50.32/28", "10.210.50.48/28"]
      intra_subnets                    = ["10.210.50.0/28", "10.210.50.16/28"] # transit gateway attachment subnets
    }

    # Lendscape CIDR
    network_account_cidr = "10.210.120.0/22"

    # nginx config
    nginx_config = {
      instance_type = {
        "tier1" = "t3.medium"
        "tier2" = "t2.small"
        "tier3" = "t2.small"
      }
      ami = {
        "eu-west-2" = "ami-0b2d450478e05ad6d"
        "eu-west-1" = "ami-04b9c4c3b112ff925"
      }
    }

    # HALO config
    halo_config = {
      instance_type = {
        "tier1" = "m5.large"
        "tier2" = "t2.small"
        "tier3" = "t2.small"
      }
      # Microsoft Windows Server 2022 Base
      ami = {
        "eu-west-2" = "ami-004128c5853c91821"
        "eu-west-1" = "ami-00c896faf296575ab"
      }
    }

    # AURA config
    aura_config = {
      instance_type = {
        "tier1" = "m5.large"
        "tier2" = "t2.small"
        "tier3" = "t2.small"
      }
      # Microsoft Windows Server 2022 Base
      ami = {
        "eu-west-2" = "ami-004128c5853c91821"
        "eu-west-1" = "ami-00c896faf296575ab"
      }
    }

    # CORE config
    core_config = {
      number_of_secondary_ips = 2
      instance_type = {
        "tier1" = "c5.2xlarge"
        "tier2" = "t2.small"
        "tier3" = "t2.small"
      }
      # Microsoft Windows Server 2022 Base
      ami = {
        "eu-west-2" = "ami-004128c5853c91821"
        "eu-west-1" = "ami-00c896faf296575ab"
      }
      create_fsx              = false
      fsx_storage_type        = "SSD"
      fsx_storage_capacity    = 300
      fsx_throughput_capacity = 16
      fsx_deployment_type     = "SINGLE_AZ_1"
    }

    # MDB config
    mdb_config = {
      number_of_secondary_ips = 2
      instance_type = {
        "tier1" = "r5.2xlarge"
        "tier2" = "t2.small"
        "tier3" = "t2.small"
      }
      # Microsoft Windows Server 2022 with SQL Server 2022 Enterprise
      ami = {
        "eu-west-2" = "ami-0c5db8f6af69d3e91"
        "eu-west-1" = "ami-04ed1f78d22d2b6ee"
      }
      create_fsx              = false
      fsx_storage_type        = "SSD"
      fsx_storage_capacity    = 300
      fsx_throughput_capacity = 16
      fsx_deployment_type     = "SINGLE_AZ_1"
    }

    # RDB config
    rdb_config = {
      number_of_secondary_ips = 2
      instance_type = {
        "tier1" = "r5.2xlarge"
        "tier2" = "t2.small"
        "tier3" = "t2.small"
      }
      # Microsoft Windows Server 2022 with SQL Server 2022 Enterprise
      ami = {
        "eu-west-2" = "ami-0c5db8f6af69d3e91"
        "eu-west-1" = "ami-04ed1f78d22d2b6ee"
      }
      create_fsx              = false
      fsx_storage_type        = "SSD"
      fsx_storage_capacity    = 300
      fsx_throughput_capacity = 16
      fsx_deployment_type     = "SINGLE_AZ_1"
    }

    workhours         = "cron(0 7 ? * MON-FRI *)"  # adjusted from 8 to 7 for UTC
    out_of_workhours  = "cron(0 0 ? * MON-FRI *)" # adjusted from 20 to 19 for UTC
    delayed_workhours = "cron(5 7 ? * MON-FRI *)"  # adjusted from 8 to 7 for UTC
  }
}