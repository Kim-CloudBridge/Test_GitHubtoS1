locals {
  region               = "eu-west-2"
  common_prefix        = join("", [module.global_vars.global.naming_convention.regions[local.region]])
  env_domain           = "m"
  client_id            = "0000"
  tier                 = "tier0"
  network_account_cidr = "10.210.120.0/22"
  application_name     = "jenkins"

  ssm_role_name = join("-", [module.global_vars.global.naming_convention.product, join("", [local.common_prefix, "x"]), 
    join("", [local.client_id, local.env_domain]), module.global_vars.global.naming_convention.JENKINS,
    local.env_domain, module.global_vars.global.naming_convention.ROLE
  ])

  ssm_instance_profile_name = join("-", [module.global_vars.global.naming_convention.product, join("", [local.common_prefix, "x"]), 
    join("", [local.client_id, local.env_domain]), module.global_vars.global.naming_convention.JENKINS,
    module.global_vars.global.naming_convention.INSTANCE_PROFILE
  ])

  jenkins_instance_name = join("-", [module.global_vars.global.naming_convention.product, join("", [local.common_prefix, "a"]), 
    join("", [local.client_id, local.env_domain]), module.global_vars.global.naming_convention.JENKINS, "m",
    module.global_vars.global.naming_convention.EC2, "01"
  ])

  secrets_manager_policy_name = join("-", [module.global_vars.global.naming_convention.product, join("", [local.common_prefix, "x"]),
    module.global_vars.global.naming_convention.POLICY,
    module.global_vars.global.naming_convention.SSM
  ])

  jenkins_hostname = join("-", [join("", [local.client_id, local.env_domain]), module.global_vars.global.naming_convention.JENKINS, "x"])

  tags = merge(
    module.global_vars.global.tags,
    {
      "Client Number" = "0000",
      "Service"       = module.global_vars.global.tagging_convention.service_tag.CICD,
      "Product"       = module.global_vars.global.tagging_convention.service_tag.CICD,
      "Component"     = module.global_vars.global.tagging_convention.service_tag.CICD,
      "Tier"          = "T0",
      "Environment"   = "${module.global_vars.global.tagging_convention.service_tag.CICD}0000${local.env_domain}",
    }
  )

  mgmt_sec_grp_id   = data.terraform_remote_state.cicd_components.outputs.cicd_mgmt_sec_group
  cicd_vpc          = data.terraform_remote_state.cicd_components.outputs.cicd_vpc
  cicd_vpc_subnets  = data.terraform_remote_state.cicd_components.outputs.cicd_vpc_subnet_ids
  firewall_vpc_cidr = data.terraform_remote_state.north_south_firewall.outputs.firewall_vpc_cidr
  ad_dns_name       = data.terraform_remote_state.managed_ad.outputs.managed_ad_dns_name

  jenkins_security_group_ingress_rules = [
    {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = [local.network_account_cidr]
      description = "Allow HTTP traffic from firewall"
    },
    {
      type        = "ingress"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = [local.network_account_cidr]
      description = "Allow Jenkins application traffic from firewall"
    }
  ]
  jenkins_security_group_egress_rules = [
    {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound"
    }
  ]
}