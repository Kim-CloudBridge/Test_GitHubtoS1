# VPC
resource "aws_vpc" "firewall_vpc" { #fg1013
  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s-%s-vpc",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature
      )
    }
  )
  enable_dns_support               = true
  enable_dns_hostnames             = true
  cidr_block                       = var.firewall_cidr_block
  assign_generated_ipv6_cidr_block = false
}

# IGW
resource "aws_internet_gateway" "firewall_igw" { #fg1014
  vpc_id = aws_vpc.firewall_vpc.id
  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s-%s-igw",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature
      )
    }
  )
}

# Route Tables

resource "aws_route_table" "fw_spv_01_rtb" { #fg1015
  count  = length(local.firewall_private_subnets[0]) # 2
  vpc_id = aws_vpc.firewall_vpc.id
  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s-%s-spv-rtb-0%d",
        local.nomenclature_1,
        substr(element(local.azs, count.index), -1, -1),
        local.firewall_nomenclature,
        1
      )
    }
  )
}

resource "aws_route_table" "fw_spv_02_rtb" { #fg1016
  vpc_id = aws_vpc.firewall_vpc.id
  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s-%s-spv-rtb-0%d",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature,
        2
      )
    }
  )
}

resource "aws_route_table" "fw_spb_01_rtb" { #fg1017
  vpc_id = aws_vpc.firewall_vpc.id
  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s-%s-spb-rtb-0%d",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature,
        1
      )
    }
  )
}

# Routes 

resource "aws_route" "spb_01_rtb_tgw_route" { #fg1017
  route_table_id         = aws_route_table.fw_spb_01_rtb.id
  destination_cidr_block = local.site_network
  transit_gateway_id     = local.transit_gateway_id
}

resource "aws_route" "spb_01_rtb_igw_route" { #fg1017
  route_table_id         = aws_route_table.fw_spb_01_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.firewall_igw.id
}

# Subnets

resource "aws_subnet" "fw_spv_01" { #fg1018
  count                = length(local.firewall_private_subnets[0]) # 2
  vpc_id               = aws_vpc.firewall_vpc.id
  cidr_block           = local.firewall_private_subnets[0][count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null

  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s-%s-spv-0%d",
        local.nomenclature_1,
        substr(element(local.azs, count.index), -1, -1),
        local.firewall_nomenclature,
        1
      )
    }
  )
}

resource "aws_subnet" "fw_spv_02" { #fg1019
  count                = length(local.firewall_private_subnets[1]) # 2
  vpc_id               = aws_vpc.firewall_vpc.id
  cidr_block           = local.firewall_private_subnets[1][count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null

  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s-%s-spv-0%d",
        local.nomenclature_1,
        substr(element(local.azs, count.index), -1, -1),
        local.firewall_nomenclature,
        2
      )
    }
  )
}

resource "aws_subnet" "fw_spb_01" { #fg1020
  count                = length(var.firewall_public_subnets) # 2
  vpc_id               = aws_vpc.firewall_vpc.id
  cidr_block           = var.firewall_public_subnets[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null

  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s-%s-spb-0%d",
        local.nomenclature_1,
        substr(element(local.azs, count.index), -1, -1),
        local.firewall_nomenclature,
        1
      )
    }
  )
}

# Route Table Association
resource "aws_route_table_association" "fw_spv_01" {
  count          = length(local.firewall_private_subnets[0]) # 2
  subnet_id      = element(aws_subnet.fw_spv_01[*].id, count.index)
  route_table_id = aws_route_table.fw_spv_01_rtb[count.index].id
}

resource "aws_route_table_association" "fw_spv_02" {
  count          = length(local.firewall_private_subnets[1]) # 2
  subnet_id      = element(aws_subnet.fw_spv_02[*].id, count.index)
  route_table_id = aws_route_table.fw_spv_02_rtb.id
}

resource "aws_route_table_association" "fw_spb_01" {
  count          = length(var.firewall_public_subnets) # 2
  subnet_id      = element(aws_subnet.fw_spb_01[*].id, count.index)
  route_table_id = aws_route_table.fw_spb_01_rtb.id
}

# Private Network ACLs

resource "aws_network_acl" "fw_spv_01_acl" { #fg1021
  subnet_ids = toset(flatten([for subnet in aws_subnet.fw_spv_01 : subnet.id]))

  vpc_id = aws_vpc.firewall_vpc.id

  dynamic "ingress" {
    for_each = var.default_network_acl_ingress
    content {
      action          = ingress.value.action
      cidr_block      = lookup(ingress.value, "cidr_block", null)
      from_port       = ingress.value.from_port
      icmp_code       = lookup(ingress.value, "icmp_code", null)
      icmp_type       = lookup(ingress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
      protocol        = ingress.value.protocol
      rule_no         = ingress.value.rule_no
      to_port         = ingress.value.to_port
    }
  }
  dynamic "egress" {
    for_each = var.default_network_acl_egress
    content {
      action          = egress.value.action
      cidr_block      = lookup(egress.value, "cidr_block", null)
      from_port       = egress.value.from_port
      icmp_code       = lookup(egress.value, "icmp_code", null)
      icmp_type       = lookup(egress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
      protocol        = egress.value.protocol
      rule_no         = egress.value.rule_no
      to_port         = egress.value.to_port
    }
  }

  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s-%s-spv-acl-0%d",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature,
        1
      )
    }
  )
}

resource "aws_network_acl" "fw_spv_02_acl" { #fg1022
  subnet_ids = toset(flatten([for subnet in aws_subnet.fw_spv_02 : subnet.id]))


  vpc_id = aws_vpc.firewall_vpc.id

  dynamic "ingress" {
    for_each = var.default_network_acl_ingress
    content {
      action          = ingress.value.action
      cidr_block      = lookup(ingress.value, "cidr_block", null)
      from_port       = ingress.value.from_port
      icmp_code       = lookup(ingress.value, "icmp_code", null)
      icmp_type       = lookup(ingress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
      protocol        = ingress.value.protocol
      rule_no         = ingress.value.rule_no
      to_port         = ingress.value.to_port
    }
  }
  dynamic "egress" {
    for_each = var.default_network_acl_egress
    content {
      action          = egress.value.action
      cidr_block      = lookup(egress.value, "cidr_block", null)
      from_port       = egress.value.from_port
      icmp_code       = lookup(egress.value, "icmp_code", null)
      icmp_type       = lookup(egress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
      protocol        = egress.value.protocol
      rule_no         = egress.value.rule_no
      to_port         = egress.value.to_port
    }
  }

  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s-%s-spv-acl-0%d",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature,
        2
      )
    }
  )
}

# Public Network ACLs

resource "aws_network_acl" "fw_spb_01_acl" { #fg1023
  subnet_ids = toset(flatten([for subnet in aws_subnet.fw_spb_01 : subnet.id]))

  vpc_id = aws_vpc.firewall_vpc.id

  dynamic "ingress" {
    for_each = var.default_network_acl_ingress
    content {
      action          = ingress.value.action
      cidr_block      = lookup(ingress.value, "cidr_block", null)
      from_port       = ingress.value.from_port
      icmp_code       = lookup(ingress.value, "icmp_code", null)
      icmp_type       = lookup(ingress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
      protocol        = ingress.value.protocol
      rule_no         = ingress.value.rule_no
      to_port         = ingress.value.to_port
    }
  }
  dynamic "egress" {
    for_each = var.default_network_acl_egress
    content {
      action          = egress.value.action
      cidr_block      = lookup(egress.value, "cidr_block", null)
      from_port       = egress.value.from_port
      icmp_code       = lookup(egress.value, "icmp_code", null)
      icmp_type       = lookup(egress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
      protocol        = egress.value.protocol
      rule_no         = egress.value.rule_no
      to_port         = egress.value.to_port
    }
  }

  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s-%s-spb-acl-0%d",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature,
        1
      )
    }
  )
}

# Flow Logs
# resource "aws_flow_log" "firewall_vpc" {
#   log_destination      = var.flow_log_s3_destination
#   log_destination_type = "s3"
#   log_format           = var.log_format
#   traffic_type         = var.traffic_type
#   vpc_id               = aws_vpc.firewall_vpc.id
# #   iam_role_arn    = aws_iam_role.flow_logs.arn
#     tags = merge(
#         local.tags,
#         {
#           "Name" = format("%s%s-%s-vpc-fl",
#             local.nomenclature_1,
#             "x",
#             local.firewall_nomenclature,
#           )
#         }
#       )
# }