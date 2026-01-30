locals {

  # Management Security Group
  # Management specific customer and environment ingres and egress
  management_security_group_ingress_rules = [
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

  # NLB Aura Security Group
  # NLB Aura specific customer and environment ingres and egress rules for NLB Aura
  nlb_aura_security_group_ingress_rules = []
  nlb_aura_security_group_egress_rules  = []

  # Aura Security Group
  # Aura specific customer and environment ingres and egress rules for Aura
  aura_security_group_ingress_rules = []
  aura_security_group_egress_rules  = []

  # NLB Halo Security Group
  # NLB Halo specific customer and environment ingres and egress rules for NLB Halo
  nlb_halo_security_group_ingress_rules = [
    {
      type        = "ingress"
      from_port   = 8081
      to_port     = 8081
      protocol    = "tcp"
      cidr_blocks = [
        module.global_vars.global.lendscape_landing_zone_networks["${var.region}"]["shared_test_domain_dmz"]
      ]
      description = "Allow access from DMZ"
    },
  ]
  nlb_halo_security_group_egress_rules  = []

  # Halo Security Group
  # Halo specific customer and environment ingres and egress rules for Halo
  halo_security_group_ingress_rules = []
  halo_security_group_egress_rules  = []

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
    # HALO config
    halo_config = {
      instance_type = {
        "tier1" = "m5.large"
        "tier2" = "t2.small"
        "tier3" = "c5.2xlarge"
      }
      # Microsoft Windows Server 2022 Base
      ami = {
        "eu-west-2" = "ami-0276f49d1f94587d1"
      }
      ad_tags = {
        "ADJoined"         = "true",
        "ADHostnamePrefix" = upper("${var.client_id}${var.env_suffix}-HLT3"),
        "ADOrgUnit"        = "OU=client0123Test,OU=lscloud,DC=lscloud,DC=systems"
      }
    }

    # AURA config
    aura_config = {
      instance_type = {
        "tier1" = "m5.large"
        "tier2" = "t2.small"
        "tier3" = "c5.2xlarge"
      }
      # Microsoft Windows Server 2022 Base
      ami = {
        "eu-west-2" = "ami-0276f49d1f94587d1"
      }
      ad_tags = {
        "ADJoined"         = "true",
        "ADHostnamePrefix" = upper("${var.client_id}${var.env_suffix}-ART3"),
        "ADOrgUnit"        = "OU=client0123Test,OU=lscloud,DC=lscloud,DC=systems"
      }
    }

    workhours         = "cron(0 7 ? * MON-FRI *)"  # adjusted from 8 to 7 for UTC
    out_of_workhours  = "cron(0 19 ? * MON-FRI *)" # adjusted from 20 to 19 for UTC
    delayed_workhours = "cron(5 7 ? * MON-FRI *)"  # adjusted from 8 to 7 for UTC
  }
  ad_vpc_cidr_block = data.terraform_remote_state.managed_ad.outputs.shared_svcs_vpc_cidr

  client_env                    = join("", [var.client_id, var.env_suffix])
  common_prefix_general_service = join("", [module.global_vars.global.naming_convention.regions[var.region], module.global_vars.global.naming_convention.GLOBAL_SERVICE])

  vpc_fl_tags = merge({
    Name : join("-", [
      module.global_vars.global.naming_convention.product, local.common_prefix_general_service, local.client_env,
      module.global_vars.global.naming_convention.VPC, "FL", "01"
    ])
  }, local.tags)

  client_vpc_ids = [module.app_vpc.vpc_id]

  ssm_role_name = join("-", [module.global_vars.global.naming_convention.product, local.common_prefix_general_service, local.client_env,
    module.global_vars.global.naming_convention.ROLE,
    module.global_vars.global.naming_convention.SSM, "02"
  ])

  secrets_manager_policy_name = join("-", [module.global_vars.global.naming_convention.product, local.common_prefix_general_service, local.client_env,
    module.global_vars.global.naming_convention.POLICY,
    module.global_vars.global.naming_convention.SSM, "02"
  ])

  ssm_instance_profile_name = join("-", [module.global_vars.global.naming_convention.product, local.common_prefix_general_service, local.client_env,
    module.global_vars.global.naming_convention.INSTANCE_PROFILE,
    module.global_vars.global.naming_convention.SSM, "02"
  ])

  tags = merge(module.global_vars.global.tags, {
    "Client Number" = var.client_id,
    "Service"       = module.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Product"       = module.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Component"     = "${module.global_vars.global.tagging_convention.service_tag.LENDSCAPE}-DMZ-VPC",
    "Tier"          = upper(replace(var.tier, "ier", "")),
    "Environment"   = "${module.global_vars.global.tagging_convention.service_tag.LENDSCAPE}${var.client_id}${var.env_domain}",
    "Domain"        = var.env_domain
  })
  # Transit gateway ID
  transit_gateway_id = data.terraform_remote_state.transit_gateway.outputs.transit_gateway_id

  # ACLs
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
  nginx_security_group_egress_rules  = []

}