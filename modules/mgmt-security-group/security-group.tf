resource "aws_security_group" "management_security_group" {
  name   = local.management_sgp_name
  vpc_id = var.vpc_id

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
  cidr_blocks       = [var.network_account_cidr]
  security_group_id = aws_security_group.management_security_group.id
  description       = "Allow SSH Traffic from Network Account"
}
resource "aws_security_group_rule" "management_rdp_ingress_rule" {
  type              = "ingress"
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  cidr_blocks       = [var.network_account_cidr]
  security_group_id = aws_security_group.management_security_group.id
  description       = "Allow RDP Traffic from Network Account"
}
