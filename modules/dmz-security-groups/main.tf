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
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nginx_security_group.id
  description       = "Allow TCP Traffic to Internet - Required by SSM"
}
resource "aws_security_group_rule" "nginx_tcp_egress_private_network_rule" {
  type              = "egress"
  from_port         = 8000
  to_port           = 18000
  protocol          = "tcp"
  cidr_blocks       = var.global_vars.global.site_networks["${var.region}_customer_range"]
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