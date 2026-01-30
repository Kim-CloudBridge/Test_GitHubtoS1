# VPC
resource "aws_vpc" "gateway_vpc" { ##fg1001
  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s-%s-vpc",
        local.nomenclature_1,
        "x",
        local.gateway_nomenclature
      )
    }
  )
  enable_dns_support               = true
  enable_dns_hostnames             = true
  cidr_block                       = var.gateway_cidr_block
  assign_generated_ipv6_cidr_block = false
}

# Route Tables

resource "aws_route_table" "spv_01_rtb" { #fg1002
  count  = length(local.gateway_private_subnets[0]) # 2
  vpc_id = aws_vpc.gateway_vpc.id
  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s-%s-spv-rtb-0%d",
        local.nomenclature_1,
        substr(element(local.azs, count.index), -1, -1),
        local.gateway_nomenclature,
        1
      )
    }
  )
}

resource "aws_route_table" "spv_02_rtb" { #fg1003
  vpc_id = aws_vpc.gateway_vpc.id
  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s-%s-spv-rtb-0%d",
        local.nomenclature_1,
        "x",
        local.gateway_nomenclature,
        2
      )
    }
  )
}

# Subnets

resource "aws_subnet" "spv_01" { #fg1004
  count                = length(local.gateway_private_subnets[0]) # 2
  vpc_id               = aws_vpc.gateway_vpc.id
  cidr_block           = local.gateway_private_subnets[0][count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null

  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s-%s-spv-0%d",
        local.nomenclature_1,
        substr(element(local.azs, count.index), -1, -1),
        local.gateway_nomenclature,
        1
      )
    }
  )
}

resource "aws_subnet" "spv_02" { #fg1005
  count                = length(local.gateway_private_subnets[1]) # 2
  vpc_id               = aws_vpc.gateway_vpc.id
  cidr_block           = local.gateway_private_subnets[1][count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null

  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s-%s-spv-0%d",
        local.nomenclature_1,
        substr(element(local.azs, count.index), -1, -1),
        local.gateway_nomenclature,
        2
      )
    }
  )
}

# Routes 

resource "aws_route" "spv_02_rtb_tgw_route" { 
  route_table_id         = aws_route_table.spv_02_rtb.id
  destination_cidr_block = local.site_network
  transit_gateway_id     = local.transit_gateway_id
}

resource "aws_route" "spv_02_rtb_dmz_tgw_route" { 
  route_table_id         = aws_route_table.spv_02_rtb.id
  destination_cidr_block = local.site_network_dmz
  transit_gateway_id     = local.transit_gateway_id
}

# Route Table Association

resource "aws_route_table_association" "spv_01" {
  count     = length(local.gateway_private_subnets[0]) # 2
  subnet_id = element(aws_subnet.spv_01[*].id, count.index)
  route_table_id = element(
    aws_route_table.spv_01_rtb[*].id,
    count.index,
  )
}

resource "aws_route_table_association" "spv_02" {
  count          = length(local.gateway_private_subnets[1]) # 2
  subnet_id      = element(aws_subnet.spv_02[*].id, count.index)
  route_table_id = aws_route_table.spv_02_rtb.id
}

# Private Network ACLs

resource "aws_network_acl" "spv_01_acl" { #fg1006

  subnet_ids = toset(flatten([for subnet in aws_subnet.spv_01 : subnet.id]))

  vpc_id = aws_vpc.gateway_vpc.id

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
        local.gateway_nomenclature,
        1
      )
    }
  )
}

resource "aws_network_acl" "spv_02_acl" { #fg1007
  subnet_ids = toset(flatten([for subnet in aws_subnet.spv_02 : subnet.id]))

  vpc_id = aws_vpc.gateway_vpc.id

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
        local.gateway_nomenclature,
        2
      )
    }
  )
}

# Flow Logs
# resource "aws_flow_log" "gateway_vpc" {
#   log_destination      = var.flow_log_s3_destination
#   log_destination_type = "s3"
#   log_format           = var.log_format
#   traffic_type         = var.traffic_type
#   vpc_id               = aws_vpc.gateway_vpc.id
#       tags = merge(
#         local.tags,
#         {
#           "Name" = format("%s%s-%s-vpc-fl",
#             local.nomenclature_1,
#             "x",
#             local.gateway_nomenclature,
#           )
#         }
#       )
# #   iam_role_arn    = aws_iam_role.flow_logs.arn
# }