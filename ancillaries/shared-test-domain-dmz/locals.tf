locals {

  # Management Security Group
  # Management specific customer and environment ingres and egress
  management_security_group_ingress_rules = []
  management_security_group_egress_rules = []

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
  nlb_halo_security_group_ingress_rules = []
  nlb_halo_security_group_egress_rules  = []

  # Halo Security Group
  # Halo specific customer and environment ingres and egress rules for Halo
  halo_security_group_ingress_rules = []
  halo_security_group_egress_rules  = []

  environment = {
    region                       = var.region
    waf_scope                    = module.global_vars.global.WAF_REGIONAL_SCOPE
    waf_logging                  = true
    managed_instances_start_stop = true

    # @TODO Fix this, the current refactor for the security group in "tier3" branch is creating
    # nlb_aura_ingress_dmz group rule and it's referencing to var.environment.dmz.cidr
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

    nginx_config = {
      instance_type = {
        "tier0" = "t3.medium"
        "tier1" = "t3.medium"
        "tier2" = "t2.small"
        "tier3" = "t2.small"
      }
      ami = {
        "eu-west-2" = "ami-0b2d450478e05ad6d"
        "eu-west-1" = "ami-04b9c4c3b112ff925"
      }
    }
    workhours         = "cron(0 7 ? * MON-FRI *)"  # adjusted from 8 to 7 for UTC
    out_of_workhours  = "cron(0 19 ? * MON-FRI *)" # adjusted from 20 to 19 for UTC
    delayed_workhours = "cron(5 7 ? * MON-FRI *)"  # adjusted from 8 to 7 for UTC
  }

  client_env                    = join("", [var.client_id, var.env_suffix])
  common_prefix_general_service = join("", [module.global_vars.global.naming_convention.regions[var.region], module.global_vars.global.naming_convention.GLOBAL_SERVICE])

  vpc_fl_tags = merge({
    Name : join("-", [
      module.global_vars.global.naming_convention.product, local.common_prefix_general_service, local.client_env,
      module.global_vars.global.naming_convention.VPC, "FL", "01"
    ])
  }, local.tags)

  ssm_role_name = join("-", [module.global_vars.global.naming_convention.product, local.common_prefix_general_service, local.client_env,
    module.global_vars.global.naming_convention.ROLE,
    module.global_vars.global.naming_convention.SSM
  ])

  secrets_manager_policy_name = join("-", [module.global_vars.global.naming_convention.product, local.common_prefix_general_service, local.client_env,
    module.global_vars.global.naming_convention.POLICY,
    module.global_vars.global.naming_convention.SSM
  ])

  ssm_instance_profile_name = join("-", [module.global_vars.global.naming_convention.product, local.common_prefix_general_service, local.client_env,
    module.global_vars.global.naming_convention.INSTANCE_PROFILE,
    module.global_vars.global.naming_convention.SSM
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