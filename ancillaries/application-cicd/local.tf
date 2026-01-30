locals {
  transit_gateway_id = data.terraform_remote_state.transit_gateway.outputs.transit_gateway_id

  region         = "eu-west-2"
  environment_id = "n"
  client_id      = "0000"
  env_domain     = "MGMT"
  tier = "tier0"
  network_account_cidr = "10.210.120.0/22"
  common_prefix = join("", [module.global_vars.global.naming_convention.regions[local.region]])
  application_name = "cicd-corp-access"
  

  artifacts_bucket_name = join("-", [module.global_vars.global.naming_convention.product, join("", [local.common_prefix, "x"]), join("", [local.client_id, local.environment_id]),
    "artifacts", module.global_vars.global.naming_convention.S3, "01"
  ])

  cicd_vpc = {
    cidr            = "10.210.112.0/25"
    enabled_azs     = ["a", "b"]
    private_subnets = ["10.210.112.32/27", "10.210.112.64/27"]
    tgw_subnets     = ["10.210.112.0/28", "10.210.112.16/28"] # transit gateway attachment subnets
    
  }

  common_prefix_general_service = join("", [module.global_vars.global.naming_convention.regions[local.region],
  
  module.global_vars.global.naming_convention.GLOBAL_SERVICE])
  ad_cidr              = data.terraform_remote_state.managed_ad.outputs.private_subnets_cidr
  ad_vpc_cidr_block    = data.terraform_remote_state.managed_ad.outputs.shared_svcs_vpc_cidr
  

  nomenclature_1 = "${module.global_vars.global.naming_convention.product}-${module.global_vars.global.naming_convention.regions[local.region]}"
  nomenclature_2 = "${local.client_id}${local.environment_id}"
  azs = [
    "${local.region}a",
    "${local.region}b",
  ]

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

  s3_external_account_access = ["967702029755"]

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
    },
    {
      type        = "ingress"
      from_port   = 53
      to_port     = 53
      protocol    = "tcp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "DNS"
    },
    {
      type        = "ingress"
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "DNS"
    },
    {
      type        = "ingress"
      from_port   = 3268
      to_port     = 3269
      protocol    = "tcp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "ingress"
      from_port   = 464
      to_port     = 464
      protocol    = "tcp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "ingress"
      from_port   = 49152
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "ingress"
      from_port   = 123
      to_port     = 123
      protocol    = "udp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "ingress"
      from_port   = 389
      to_port     = 389
      protocol    = "udp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "ingress"
      from_port   = 88
      to_port     = 88
      protocol    = "udp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "ingress"
      from_port   = 389
      to_port     = 389
      protocol    = "tcp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "ingress"
      from_port   = 9389
      to_port     = 9389
      protocol    = "tcp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "ingress"
      from_port   = 88
      to_port     = 88
      protocol    = "tcp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "ingress"
      from_port   = 464
      to_port     = 464
      protocol    = "udp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Active Directory Rules"
    },
    {
      type        = "ingress"
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = [local.ad_vpc_cidr_block]
      description = "Ping All"
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


}