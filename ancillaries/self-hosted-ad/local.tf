locals {
  region             = "eu-west-2"
  env_domain         = "m"
  transit_gateway_id = data.terraform_remote_state.transit_gateway.outputs.transit_gateway_id

  nomenclature_1 = "${module.global_vars.global.naming_convention.product}-${module.global_vars.global.naming_convention.regions[var.region]}"
  nomenclature_2 = "${var.client_id}${var.environment_id}"
  azs = [
    "${var.region}a",
    "${var.region}b",
  ]

  private_subnets = chunklist(var.shared_private_subnets, 2)
  public_subnets  = chunklist(var.shared_public_subnets, 2)
  dns_protocols   = ["udp", "tcp"]

  tags = merge(
    module.global_vars.global.tags,
    var.common_tags,
    {
      "Client Number" = "0000",
      "Service"       = module.global_vars.global.tagging_convention.service_tag.ACTIVEDIRECTORY,
      "Product"       = module.global_vars.global.tagging_convention.service_tag.ACTIVEDIRECTORY,
      "Component"     = "${module.global_vars.global.tagging_convention.service_tag.SHAREDSERVICES}-AD",
      "Tier"          = "T0",
      "Environment"   = "${module.global_vars.global.tagging_convention.service_tag.SHAREDSERVICES}0000${var.env_domain}",
    }
  )
  common_prefix_general_service = join("", [module.global_vars.global.naming_convention.regions[local.region],
  module.global_vars.global.naming_convention.GLOBAL_SERVICE])
  ad_vpc_cidr_block    = var.shared_svcs_vpc_cidr
  ad_dns_ips           = aws_instance.ad_instance[*].private_ip
  network_account_cidr = module.global_vars.global.lendscape_landing_zone_networks.eu-west-2.east_west_firewall
  # self_hosted_security_group_id = aws_security_group.self_hosted_ec2_sgp.id
  self_hosted_security_group_ingress_rules = [
    {
      type        = "ingress"
      from_port   = 1024
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Ephemeral ports for RPC"
    },
    {
      type        = "ingress"
      from_port   = 3268
      to_port     = 3269
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Microsoft Global Catalog"
    },
    {
      type        = "ingress"
      from_port   = 445
      to_port     = 445
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow SMB traffic"
    },
    {
      type        = "ingress"
      from_port   = 0
      to_port     = 0
      protocol    = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow ICMP traffic"
    },
    {
      type        = "ingress"
      from_port   = 389
      to_port     = 389
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow LDAP traffic"
    },
    {
      type        = "ingress"
      from_port   = 88
      to_port     = 88
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow Kerberos authentication"
    },
    {
      type        = "ingress"
      from_port   = 88
      to_port     = 88
      protocol    = "UDP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow kerberos authentication"
    },
    {
      type        = "ingress"
      from_port   = 464
      to_port     = 464
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow Change/set password"
    },
    {
      type        = "ingress"
      from_port   = 464
      to_port     = 464
      protocol    = "UDP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow change/set password"
    },
    {
      type        = "ingress"
      from_port   = 135
      to_port     = 135
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow DCE / EPMAP"
    },
    {
      type        = "ingress"
      from_port   = 123
      to_port     = 123
      protocol    = "UDP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow NTP traffic"
    },
    {
      type        = "ingress"
      from_port   = 138
      to_port     = 138
      protocol    = "UDP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "-"
    },
    {
      type        = "ingress"
      from_port   = 389
      to_port     = 389
      protocol    = "UDP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow LDAP traffic"
    },
    {
      type        = "ingress"
      from_port   = 636
      to_port     = 636
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow LDAPS traffic"
    },
    {
      type        = "ingress"
      from_port   = 53
      to_port     = 53
      protocol    = "UDP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow DNS traffic from all"
    },
    {
      type        = "ingress"
      from_port   = 53
      to_port     = 53
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow DNS traffic from all"
    },
    {
      type        = "ingress"
      type        = "RDP"
      from_port   = 3389
      to_port     = 3389
      protocol    = "TCP"
      cidr_blocks = [local.network_account_cidr]
      description = "Allow RDP traffic from Network account"
    }
  ]
  self_hosted_security_group_egress_rules = [
    {
      type        = "egress"
      from_port   = 53
      to_port     = 53
      protocol    = "UDP"
      cidr_blocks = [join("", [local.ad_dns_ips[0], "/32"]), join("", [local.ad_dns_ips[1], "/32"])]
      description = "Allow DNS traffic"
    },
    {
      type        = "egress"
      from_port   = 53
      to_port     = 53
      protocol    = "TCP"
      cidr_blocks = [join("", [local.ad_dns_ips[0], "/32"]), join("", [local.ad_dns_ips[1], "/32"])]
      description = "Allow DNS traffic"
    },
    {
      type        = "egress"
      from_port   = 0
      to_port     = 65535
      protocol    = "TCP"
      cidr_blocks = ["10.210.0.0/16"]
      description = "Temporary"
    },
    {
      type        = "egress"
      from_port   = 443
      to_port     = 443
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPs traffic to Internet"
    },
    {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [join("", [local.ad_dns_ips[0], "/32"]), join("", [local.ad_dns_ips[1], "/32"])]
      description = "Allow all traffic to self"
    }
  ]

}


