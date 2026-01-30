# Management Security Group
# =========================
#sg_corp
resource "aws_security_group" "management_security_group" {
  name   = local.management_sgp_name
  vpc_id = var.app_vpc.vpc_id

  tags = merge({
    Name = local.management_sgp_name
  }, local.tags)
}
resource "aws_security_group_rule" "management_dynamic_ingress" {
  for_each = { for rule in var.management_security_group_ingress_rules : "${rule.type}-${rule.protocol}-${rule.from_port}-${rule.to_port}-${rule.description}" => rule if rule.type == "ingress" }

  type              = "ingress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.management_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "management_dynamic_egress" {
  for_each = { for rule in var.management_security_group_egress_rules : "${rule.type}-${rule.protocol}-${rule.from_port}-${rule.to_port}-${rule.description}" => rule if rule.type == "egress" }

  type              = "egress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.management_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "management_ssh_ingress_rule" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.environment.network_account_cidr]
  security_group_id = aws_security_group.management_security_group.id
  description       = "Allow SSH Traffic from Network Account"
}
resource "aws_security_group_rule" "management_rdp_ingress_rule" {
  type              = "ingress"
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  cidr_blocks       = [var.environment.network_account_cidr]
  security_group_id = aws_security_group.management_security_group.id
  description       = "Allow RDP Traffic from Network Account"
}

# DMZ Security Groups
#====================
#sg_dmz
resource "aws_security_group" "nginx_security_group" {
  name   = local.nginx_sgp_name
  vpc_id = var.dmz_vpc.vpc_id

  tags = merge({
    Name = local.nginx_sgp_name
  }, local.tags)
}
resource "aws_security_group_rule" "nginx_dynamic_ingress" {
  for_each = { for rule in var.nginx_security_group_ingress_rules : "${rule.type}-${rule.protocol}-${rule.from_port}-${rule.to_port}" => rule if rule.type == "ingress" }

  type              = "ingress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.nginx_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "nginx_dynamic_egress" {
  for_each = { for rule in var.nginx_security_group_egress_rules : "${rule.type}-${rule.protocol}-${rule.from_port}-${rule.to_port}" => rule if rule.type == "egress" }

  type              = "egress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.nginx_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "nginx_tcp_egress_internet_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nginx_security_group.id
  description       = "Allow TCP Traffic to Internet - Required by SSM"
}
resource "aws_security_group_rule" "nginx_tcp_egress_private_network_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [var.environment.network_account_cidr]
  security_group_id = aws_security_group.nginx_security_group.id
  description       = "Allow TCP Traffic to Private Network"
}
resource "aws_security_group_rule" "nginx_ingress_from_alb" {
  type                     = "ingress"
  from_port                = 8085
  to_port                  = 8085
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nginx_security_group.id
  source_security_group_id = aws_security_group.alb_security_group.id
  description              = "Allow Traffic on port 8085 from Public ALB"
}

resource "aws_security_group" "alb_security_group" {
  name   = local.alb_sgp_name
  vpc_id = var.dmz_vpc.vpc_id

  tags = merge({
    Name = local.alb_sgp_name
  }, local.tags)
}
resource "aws_security_group_rule" "alb_dynamic_ingress" {
  for_each = { for rule in var.alb_security_group_ingress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "ingress" }

  type              = "ingress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.alb_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "alb_dynamic_egress" {
  for_each = { for rule in var.alb_security_group_egress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "egress" }

  type              = "egress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.alb_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "alb_egress_to_nginx" {
  type                     = "egress"
  from_port                = 8085
  to_port                  = 8085
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb_security_group.id
  source_security_group_id = aws_security_group.nginx_security_group.id
  description              = "Allow HTTP Traffic to Nginx"
}

# APP Security Groups
############
# NLB Halo #
############
#sg_nlb_halo
resource "aws_security_group" "nlb_halo_security_group" {
  name   = local.nlb_halo_sgp_name
  vpc_id = var.app_vpc.vpc_id

  tags = merge({
    Name = local.nlb_halo_sgp_name
  }, local.tags)
}
resource "aws_security_group_rule" "network_account_ingress" {
  type              = "ingress"
  from_port         = 8081
  to_port           = 8081
  protocol          = "tcp"
  cidr_blocks       = [var.environment.network_account_cidr]
  description       = "Allow TLS Traffic from Network Account"
  security_group_id = aws_security_group.nlb_halo_security_group.id
}
resource "aws_security_group_rule" "nlb_halo_dynamic_ingress" {
  for_each = { for rule in var.nlb_halo_security_group_ingress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "ingress" }

  type              = "ingress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.nlb_halo_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "nlb_halo_dynamic_egress" {
  for_each = { for rule in var.nlb_halo_security_group_egress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "egress" }

  type              = "egress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.nlb_halo_security_group.id
  description       = each.value["description"]
}
# Egress allowed from HALO to HALO ELB
resource "aws_security_group_rule" "elb_egress_to_halo_elb" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nlb_halo_security_group.id
  source_security_group_id = aws_security_group.halo_security_group.id
  description              = "Allow TCP Traffic to target Halo Backend"
}

########
# HALO #
########
# Halo
#sg_halo
resource "aws_security_group" "halo_security_group" {
  name   = local.halo_sgp_name
  vpc_id = var.app_vpc.vpc_id

  tags = merge({
    Name = local.halo_sgp_name
  }, local.tags)
}
resource "aws_security_group_rule" "halo_dynamic_ingress" {
  for_each = { for rule in var.halo_security_group_ingress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "ingress" }

  type              = "ingress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.halo_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "halo_dynamic_egress" {
  for_each = { for rule in var.halo_security_group_egress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "egress" }

  type              = "egress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.halo_security_group.id
  description       = each.value["description"]
}
# Ingress allowed from HALO ELB to HALO
resource "aws_security_group_rule" "elb_ingress_to_halo" {
  type                     = "ingress"
  from_port                = 8081
  to_port                  = 8081
  protocol                 = "tcp"
  security_group_id        = aws_security_group.halo_security_group.id
  source_security_group_id = aws_security_group.nlb_halo_security_group.id
  description              = "Allow TLS Traffic from NLB"
}
resource "aws_security_group_rule" "elb_egress_http_to_lendscape_core" {
  type                     = "egress"
  from_port                = 8085
  to_port                  = 8085
  protocol                 = "tcp"
  security_group_id        = aws_security_group.halo_security_group.id
  source_security_group_id = aws_security_group.nlb_core_security_group.id
  description              = "Allow HTTPs/JSON traffic to Lendscape Core"
}
resource "aws_security_group_rule" "elb_egress_hazelcast_to_lendscape_core" {
  type                     = "egress"
  from_port                = 5701
  to_port                  = 5701
  protocol                 = "tcp"
  security_group_id        = aws_security_group.halo_security_group.id
  source_security_group_id = aws_security_group.nlb_core_security_group.id
  description              = "Allow ingress traffic from ELB HALO to HALO"
}

############
# NLB AURA #
############
#sg_nlb_aura
resource "aws_security_group" "nlb_aura_security_group" {
  name   = local.nlb_aura_sgp_name
  vpc_id = var.app_vpc.vpc_id

  tags = merge({
    Name = local.nlb_aura_sgp_name
  }, local.tags)
}
resource "aws_security_group_rule" "nlb_aura_dynamic_ingress" {
  for_each = { for rule in var.nlb_aura_security_group_ingress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "ingress" }

  type              = "ingress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.nlb_aura_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "nlb_aura_dynamic_egress" {
  for_each = { for rule in var.nlb_aura_security_group_egress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "egress" }

  type              = "egress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.nlb_aura_security_group.id
  description       = each.value["description"]
}
# Egress allowed from AURA to AURA ELB
resource "aws_security_group_rule" "elb_egress_to_aura_elb" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nlb_aura_security_group.id
  source_security_group_id = aws_security_group.aura_security_group.id
  description              = "Allow Traffic to target Aura Backend"
}
resource "aws_security_group_rule" "nlb_aura_ingress_network_access" {
  type              = "ingress"
  from_port         = 8081
  to_port           = 8081
  protocol          = "tcp"
  cidr_blocks       = [var.environment.network_account_cidr]
  security_group_id = aws_security_group.nlb_aura_security_group.id
  description       = "Allow TLS Traffic from Network Account"
}
resource "aws_security_group_rule" "nlb_aura_ingress_dmz" {
  type              = "ingress"
  from_port         = 8081
  to_port           = 8081
  protocol          = "tcp"
  cidr_blocks       = [var.environment.vpc.cidr]
  security_group_id = aws_security_group.nlb_aura_security_group.id
  description       = "Allow Traffic from DMZ (NGINX)"
}

########
# AURA #
########
# Aura
#sg_aura
resource "aws_security_group" "aura_security_group" {
  name   = local.aura_sgp_name
  vpc_id = var.app_vpc.vpc_id

  tags = merge({
    Name = local.aura_sgp_name
  }, local.tags)
}
resource "aws_security_group_rule" "aura_dynamic_ingress" {
  for_each = { for rule in var.aura_security_group_ingress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "ingress" }

  type              = "ingress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.aura_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "aura_dynamic_egress" {
  for_each = { for rule in var.aura_security_group_egress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "egress" }

  type              = "egress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.aura_security_group.id
  description       = each.value["description"]
}
# Ingress allowed from Aura ELB to Aura
resource "aws_security_group_rule" "elb_ingress_to_aura" {
  type                     = "ingress"
  from_port                = 8081
  to_port                  = 8081
  protocol                 = "tcp"
  security_group_id        = aws_security_group.aura_security_group.id
  source_security_group_id = aws_security_group.nlb_aura_security_group.id
  description              = "Allow TLS Traffic from NLB"
}
resource "aws_security_group_rule" "elb_egress_jms_to_lendscape_core" {
  type                     = "egress"
  from_port                = 61616
  to_port                  = 61616
  protocol                 = "tcp"
  security_group_id        = aws_security_group.aura_security_group.id
  source_security_group_id = aws_security_group.nlb_core_security_group.id
  description              = "Allow JMS traffic to Lendscape Core"
}
resource "aws_security_group_rule" "elb_egress_hazelcast_to_lendscape_core_second" {
  type                     = "egress"
  from_port                = 5701
  to_port                  = 5701
  protocol                 = "tcp"
  security_group_id        = aws_security_group.aura_security_group.id
  source_security_group_id = aws_security_group.nlb_core_security_group.id
  description              = "Allow Hazelcast traffic to Lendscape Core"
}

########
# CORE #
########
#sg_nlb_core
# NLB Core
resource "aws_security_group" "nlb_core_security_group" {
  name   = local.nlb_core_sgp_name
  vpc_id = var.app_vpc.vpc_id

  tags = merge({
    Name = local.nlb_core_sgp_name
  }, local.tags)
}
resource "aws_security_group_rule" "nlb_core_dynamic_ingress" {
  for_each = { for rule in var.nlb_core_security_group_ingress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "ingress" }

  type              = "ingress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.nlb_core_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "nlb_core_dynamic_egress" {
  for_each = { for rule in var.nlb_core_security_group_egress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "egress" }

  type              = "egress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.nlb_core_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "elb_egress_core_to_nlb_core" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nlb_core_security_group.id
  source_security_group_id = aws_security_group.core_security_group.id
  description              = "Allow All TCP Traffic to target Backend"
}
resource "aws_security_group_rule" "elb_ingress_core_to_nlb_core" {
  type                     = "ingress"
  from_port                = 61616
  to_port                  = 61616
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nlb_core_security_group.id
  source_security_group_id = aws_security_group.core_security_group.id
  description              = "Allow JMS from core (test)"
}
resource "aws_security_group_rule" "nlb_core_allow_halo_api" {
  type                     = "ingress"
  from_port                = 8085
  to_port                  = 8085
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nlb_core_security_group.id
  source_security_group_id = aws_security_group.halo_security_group.id
  description              = "Allow API Traffic from Halo"
}
resource "aws_security_group_rule" "nlb_core_allow_halo_hazelcast" {
  type                     = "ingress"
  from_port                = 5701
  to_port                  = 5701
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nlb_core_security_group.id
  source_security_group_id = aws_security_group.halo_security_group.id
  description              = "Allow Hazelcast Traffic from Halo"
}
resource "aws_security_group_rule" "nlb_core_allow_aura_jms" {
  type                     = "ingress"
  from_port                = 61616
  to_port                  = 61616
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nlb_core_security_group.id
  source_security_group_id = aws_security_group.aura_security_group.id
  description              = "Allow JMS traffic from Aura"
}
resource "aws_security_group_rule" "nlb_core_allow_aura_hazelcast" {
  type                     = "ingress"
  from_port                = 5701
  to_port                  = 5701
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nlb_core_security_group.id
  source_security_group_id = aws_security_group.aura_security_group.id
  description              = "Allow Hazelcast Traffic from Aura"
}

# Core
#sg_core
resource "aws_security_group" "core_security_group" {
  name   = local.core_sgp_name
  vpc_id = var.app_vpc.vpc_id

  tags = merge({
    Name = local.core_sgp_name
  }, local.tags)
}
resource "aws_security_group_rule" "core_dynamic_ingress" {
  for_each = { for rule in var.core_security_group_ingress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "ingress" }

  type              = "ingress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.core_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "core_dynamic_egress" {
  for_each          = { for rule in var.core_security_group_egress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "egress" }
  type              = "egress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.core_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "elb_egress_core_to_mdb" {
  type                     = "egress"
  from_port                = 1433
  to_port                  = 1433
  protocol                 = "tcp"
  security_group_id        = aws_security_group.core_security_group.id
  source_security_group_id = aws_security_group.mdb_security_group.id
  description              = "Allow psql traffic to M-DB"
}
resource "aws_security_group_rule" "elb_egress_core_to_rdb" {
  type                     = "egress"
  from_port                = 1433
  to_port                  = 1433
  protocol                 = "tcp"
  security_group_id        = aws_security_group.core_security_group.id
  source_security_group_id = aws_security_group.rdb_security_group.id
  description              = "Allow psql traffic to R-DB"
}
resource "aws_security_group_rule" "egress_core_self" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.core_security_group.id
  self              = true
  description       = "Allow All TCP Traffic from Self"
}
resource "aws_security_group_rule" "core_ingress_api" {
  type                     = "ingress"
  from_port                = 8085
  to_port                  = 8085
  protocol                 = "tcp"
  security_group_id        = aws_security_group.core_security_group.id
  source_security_group_id = aws_security_group.nlb_core_security_group.id
  description              = "Allow API Traffic from NLB"
}
resource "aws_security_group_rule" "core_ingress_hazelcast" {
  type                     = "ingress"
  from_port                = 5701
  to_port                  = 5701
  protocol                 = "tcp"
  security_group_id        = aws_security_group.core_security_group.id
  source_security_group_id = aws_security_group.nlb_core_security_group.id
  description              = "Allow Hazelcast Traffic from NLB"
}
resource "aws_security_group_rule" "core_ingress_jms" {
  type                     = "ingress"
  from_port                = 61616
  to_port                  = 61616
  protocol                 = "tcp"
  security_group_id        = aws_security_group.core_security_group.id
  source_security_group_id = aws_security_group.nlb_core_security_group.id
  description              = "Allow JMS traffic from NLB"
}
resource "aws_security_group_rule" "core_ingress_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  security_group_id = aws_security_group.core_security_group.id
  self              = true
  description       = "Allow All TCP Traffic to Self"
}

# DBs Security Groups
#====================
########
# M-DB #
########
#sg_mdb
resource "aws_security_group" "mdb_security_group" {
  name   = local.mdb_sgp_name
  vpc_id = var.app_vpc.vpc_id

  tags = merge({
    Name = local.mdb_sgp_name
  }, local.tags)
}
resource "aws_security_group_rule" "mdb_dynamic_ingress" {
  for_each = { for rule in var.mdb_security_group_ingress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "ingress" }

  type              = "ingress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.mdb_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "mdb_dynamic_egress" {
  for_each = { for rule in var.mdb_security_group_egress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "egress" }

  type              = "egress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.mdb_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "egress_mdb_self" {
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = -1
  security_group_id = aws_security_group.mdb_security_group.id
  self              = true
  description       = "Allow All Traffic to Self"
}
resource "aws_security_group_rule" "mdb_ingress_mssql_core" {
  type                     = "ingress"
  from_port                = 1433
  to_port                  = 1433
  protocol                 = "tcp"
  security_group_id        = aws_security_group.mdb_security_group.id
  source_security_group_id = aws_security_group.core_security_group.id
  description              = "Allow MSSQL traffic from LS Core"
}
resource "aws_security_group_rule" "mdb_ingress_mssql_network_account" {
  type              = "ingress"
  from_port         = 1433
  to_port           = 1433
  protocol          = "tcp"
  cidr_blocks       = [var.environment.network_account_cidr]
  security_group_id = aws_security_group.mdb_security_group.id
  description       = "Allow MSSQL Traffic from Network Account for access over VPN"
}
resource "aws_security_group_rule" "mdb_ingress_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
  security_group_id = aws_security_group.mdb_security_group.id
  description       = "Allow All TCP Traffic from Self"
}

########
# R-DB #
########
#sg_rdb
resource "aws_security_group" "rdb_security_group" {
  name   = local.rdb_sgp_name
  vpc_id = var.app_vpc.vpc_id

  tags = merge({
    Name = local.rdb_sgp_name
  }, local.tags)
}
resource "aws_security_group_rule" "rdb_dynamic_ingress" {
  for_each = { for rule in var.rdb_security_group_ingress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "ingress" }

  type              = "ingress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.rdb_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "rdb_dynamic_egress" {
  for_each = { for rule in var.rdb_security_group_egress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "egress" }

  type              = "egress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.rdb_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "egress_rdb_self" {
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = -1
  security_group_id = aws_security_group.rdb_security_group.id
  self              = true
  description       = "Allow All Traffic to Self"
}
resource "aws_security_group_rule" "rdb_ingress_mssql_core" {
  type                     = "ingress"
  from_port                = 1433
  to_port                  = 1433
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rdb_security_group.id
  source_security_group_id = aws_security_group.core_security_group.id
  description              = "Allow MSSQL traffic from LS Core"
}
resource "aws_security_group_rule" "rdb_ingress_mssql_network_account" {
  type              = "ingress"
  from_port         = 1433
  to_port           = 1433
  protocol          = "tcp"
  cidr_blocks       = [var.environment.network_account_cidr]
  security_group_id = aws_security_group.rdb_security_group.id
  description       = "Allow MSSQL Traffic from Network Account for access over VPN"
}
resource "aws_security_group_rule" "rdb_ingress_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
  security_group_id = aws_security_group.rdb_security_group.id
  description       = "Allow All TCP Traffic from Self"
}

########
## FSx SG
########
#sg_FSx
resource "aws_security_group" "fsx_security_group" {
  name   = local.fsx_sgp_name
  vpc_id = var.app_vpc.vpc_id

  tags = merge({
    Name = local.fsx_sgp_name
  }, local.tags)
}
resource "aws_security_group_rule" "fsx_ingress_winrm" {
  type              = "ingress"
  from_port         = 5985
  to_port           = 5985
  protocol          = "tcp"
  cidr_blocks       = [var.app_vpc.vpc_cidr_block]
  security_group_id = aws_security_group.fsx_security_group.id
  description       = "Allow WinRM Traffic for Administration from the VPC CIDR"
}
resource "aws_security_group_rule" "fsx_ingress_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
  security_group_id = aws_security_group.fsx_security_group.id
  description       = "Allow All TCP Traffic from Self"
}
resource "aws_security_group_rule" "fsx_ingress_dns_tcp" {
  type              = "ingress"
  from_port         = 53
  to_port           = 53
  protocol          = "tcp"
  cidr_blocks       = var.ew_fw_cidr
  security_group_id = aws_security_group.fsx_security_group.id
  description       = "Allow DNS traffic for AD communication"
}
resource "aws_security_group_rule" "fsx_ingress_tcp_udp" {
  type              = "ingress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  cidr_blocks       = var.ew_fw_cidr
  security_group_id = aws_security_group.fsx_security_group.id
  description       = "Allow DNS traffic for AD communication"
}
resource "aws_security_group_rule" "fsx_egress_tcp_kerberos" {
  type              = "egress"
  from_port         = 88
  to_port           = 88
  protocol          = "tcp"
  cidr_blocks       = var.ad_cidr
  security_group_id = aws_security_group.fsx_security_group.id
  description       = "Allow Kerberos authentication to AD CIDR"
}
resource "aws_security_group_rule" "fsx_egress_tcp_135" {
  type              = "egress"
  from_port         = 135
  to_port           = 135
  protocol          = "tcp"
  cidr_blocks       = var.ad_cidr
  security_group_id = aws_security_group.fsx_security_group.id
  description       = ""
}
resource "aws_security_group_rule" "fsx_egress_tcp_ldap" {
  type              = "egress"
  from_port         = 389
  to_port           = 389
  protocol          = "tcp"
  cidr_blocks       = var.ad_cidr
  security_group_id = aws_security_group.fsx_security_group.id
  description       = "Allow LDAP to AD CIDR"
}
resource "aws_security_group_rule" "fsx_egress_tcp_smb" {
  type              = "egress"
  from_port         = 445
  to_port           = 445
  protocol          = "tcp"
  cidr_blocks       = var.ad_cidr
  security_group_id = aws_security_group.fsx_security_group.id
  description       = "Allow SMB File sharing to AD CIDR"
}
resource "aws_security_group_rule" "fsx_egress_tcp_464" {
  type              = "egress"
  from_port         = 464
  to_port           = 464
  protocol          = "tcp"
  cidr_blocks       = var.ad_cidr
  security_group_id = aws_security_group.fsx_security_group.id
  description       = "Allow change/set password to AD CIDR"
}
resource "aws_security_group_rule" "fsx_egress_tcp_ldaps" {
  type              = "egress"
  from_port         = 636
  to_port           = 636
  protocol          = "tcp"
  cidr_blocks       = var.ad_cidr
  security_group_id = aws_security_group.fsx_security_group.id
  description       = "Allow LDAPS to AD CIDR"
}
resource "aws_security_group_rule" "fsx_egress_tcp_mgc" {
  type              = "egress"
  from_port         = 3268
  to_port           = 3269
  protocol          = "tcp"
  cidr_blocks       = var.ad_cidr
  security_group_id = aws_security_group.fsx_security_group.id
  description       = "Allow Microsoft Global Catalog and over SSL to AD CIDR"
}
resource "aws_security_group_rule" "fsx_egress_ad_ds_powershell" {
  type              = "egress"
  from_port         = 9389
  to_port           = 9389
  protocol          = "tcp"
  cidr_blocks       = var.ad_cidr
  security_group_id = aws_security_group.fsx_security_group.id
  description       = "Allow Microsoft AD DS and powershell to AD CIDR"
}
resource "aws_security_group_rule" "fsx_egress_rpc" {
  type              = "egress"
  from_port         = 49152
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = var.ad_cidr
  security_group_id = aws_security_group.fsx_security_group.id
  description       = "Allow Ephemeral ports for RPC to AD CIDR"
}
resource "aws_security_group_rule" "fsx_egress_dns" {
  type              = "egress"
  from_port         = 53
  to_port           = 53
  protocol          = "tcp"
  cidr_blocks       = var.ad_cidr
  security_group_id = aws_security_group.fsx_security_group.id
  description       = "Allow DNS traffic"
}
resource "aws_security_group_rule" "fsx_egress_kerberos_udp" {
  type              = "egress"
  from_port         = 88
  to_port           = 88
  protocol          = "udp"
  cidr_blocks       = var.ad_cidr
  security_group_id = aws_security_group.fsx_security_group.id
  description       = "Allow Kerberos authentication to AD CIDR"
}
resource "aws_security_group_rule" "fsx_egress_ntp_udp" {
  type              = "egress"
  from_port         = 123
  to_port           = 123
  protocol          = "udp"
  cidr_blocks       = var.ad_cidr
  security_group_id = aws_security_group.fsx_security_group.id
  description       = "Allow NTP traffic over UDP to AD CIDR"
}
resource "aws_security_group_rule" "fsx_egress_ldap_udp" {
  type              = "egress"
  from_port         = 389
  to_port           = 389
  protocol          = "udp"
  cidr_blocks       = var.ad_cidr
  security_group_id = aws_security_group.fsx_security_group.id
  description       = "Allow LDAP over UDP to AD CIDR"
}
resource "aws_security_group_rule" "fsx_egress_password_udp" {
  type              = "egress"
  from_port         = 464
  to_port           = 464
  protocol          = "udp"
  cidr_blocks       = var.ad_cidr
  security_group_id = aws_security_group.fsx_security_group.id
  description       = "Allow change/set password over UDP to AD CIDR"
}
resource "aws_security_group_rule" "fsx_egress_dns_udp" {
  type              = "egress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  cidr_blocks       = var.ad_cidr
  security_group_id = aws_security_group.fsx_security_group.id
  description       = "Allow DNS over UDP to DNS server"
}

resource "aws_security_group" "mdb_fsx_security_group" {
  name   = local.mdb_fsx_sgp_name
  vpc_id = var.app_vpc.vpc_id

  tags = merge({
    Name = local.mdb_fsx_sgp_name
  }, local.tags)
}
resource "aws_security_group_rule" "mdb_fsx_dynamic_ingress" {
  for_each = { for rule in var.mdb_fsx_security_group_ingress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "ingress" }

  type              = "ingress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.mdb_fsx_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "mdb_fsx_dynamic_egress" {
  for_each = { for rule in var.mdb_fsx_security_group_egress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "egress" }

  type              = "egress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.mdb_fsx_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "mdb_fsx_ingress_smb" {
  type                     = "ingress"
  from_port                = 445
  to_port                  = 445
  protocol                 = "tcp"
  security_group_id        = aws_security_group.mdb_fsx_security_group.id
  source_security_group_id = aws_security_group.mdb_security_group.id
  description              = "Allow SMB traffic from MDB"
}

resource "aws_security_group" "rdb_fsx_security_group" {
  name   = local.rdb_fsx_sgp_name
  vpc_id = var.app_vpc.vpc_id

  tags = merge({
    Name = local.rdb_fsx_sgp_name
  }, local.tags)
}
resource "aws_security_group_rule" "rdb_fsx_dynamic_ingress" {
  for_each = { for rule in var.rdb_fsx_security_group_ingress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "ingress" }

  type              = "ingress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.rdb_fsx_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "rdb_fsx_dynamic_egress" {
  for_each = { for rule in var.rdb_fsx_security_group_egress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "egress" }

  type              = "egress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.rdb_fsx_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "rdb_fsx_ingress_smb" {
  type                     = "ingress"
  from_port                = 445
  to_port                  = 445
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rdb_fsx_security_group.id
  source_security_group_id = aws_security_group.rdb_security_group.id
  description              = "Allow SMB traffic from RDB"
}

resource "aws_security_group" "core_fsx_security_group" {
  name   = local.core_fsx_sgp_name
  vpc_id = var.app_vpc.vpc_id

  tags = merge({
    Name = local.core_fsx_sgp_name
  }, local.tags)
}
resource "aws_security_group_rule" "core_fsx_dynamic_ingress" {
  for_each = { for rule in var.core_fsx_security_group_ingress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "ingress" }

  type              = "ingress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.core_fsx_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "core_fsx_dynamic_egress" {
  for_each = { for rule in var.core_fsx_security_group_egress_rules : "${rule.from_port}-${rule.to_port}" => rule if rule.type == "egress" }

  type              = "egress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.core_fsx_security_group.id
  description       = each.value["description"]
}
resource "aws_security_group_rule" "core_fsx_ingress_smb" {
  type                     = "ingress"
  from_port                = 445
  to_port                  = 445
  protocol                 = "tcp"
  security_group_id        = aws_security_group.core_fsx_security_group.id
  source_security_group_id = aws_security_group.core_security_group.id
  description              = "Allow SMB traffic from Core"
}
resource "aws_security_group_rule" "core_fsx_ingress_rdb" {
  type                     = "ingress"
  from_port                = 445
  to_port                  = 445
  protocol                 = "tcp"
  security_group_id        = aws_security_group.core_fsx_security_group.id
  source_security_group_id = aws_security_group.rdb_security_group.id
  description              = "Allow SMB traffic from RDB"
}
resource "aws_security_group_rule" "core_fsx_ingress_mdb" {
  type                     = "ingress"
  from_port                = 445
  to_port                  = 445
  protocol                 = "tcp"
  security_group_id        = aws_security_group.core_fsx_security_group.id
  source_security_group_id = aws_security_group.mdb_security_group.id
  description              = "Allow SMB traffic from MDB"
}

# AppStream security group and association (it's an optional module, depending on enable_appstream)
resource "aws_security_group" "appstream_security_group" {
  count = var.enable_appstream ? 1 : 0

  name   = local.appstream_sgp_name
  vpc_id = var.app_vpc.vpc_id

  tags = merge({
    Name = local.appstream_sgp_name
  }, local.tags)
}
resource "aws_security_group_rule" "appstream_to_nlb_core_ingress_smb" {
  count = var.enable_appstream ? 1 : 0

  type                     = "ingress"
  from_port                = 61616
  to_port                  = 61616
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nlb_core_security_group.id
  source_security_group_id = aws_security_group.appstream_security_group[count.index].id
  description              = "Allow JMS from AppStream"
}
resource "aws_security_group_rule" "appstream_tcp_egress_internet_rule" {
  count = var.enable_appstream ? 1 : 0

  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.appstream_security_group[count.index].id
  description       = "Allow TCP Traffic to Internet for AppStream"
}
resource "aws_security_group_rule" "appstream_to_core_ingress" {
  count = var.enable_appstream ? 1 : 0

  type                     = "ingress"
  from_port                = 61616
  to_port                  = 61616
  protocol                 = "tcp"
  security_group_id        = aws_security_group.core_security_group.id
  source_security_group_id = aws_security_group.appstream_security_group[count.index].id
  description              = "Allow JMS from AppStream"
}