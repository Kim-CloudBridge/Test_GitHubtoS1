# VPC
resource "aws_vpc" "firewall_vpc" { #fg2001
  tags = merge(
    var.tags,
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
resource "aws_internet_gateway" "firewall_igw" { #fg2015
  vpc_id = aws_vpc.firewall_vpc.id
  tags = merge(
    var.tags,
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

resource "aws_route_table" "fw_spv_01_rtb" { #fg2034 #fg2035
  count  = length(local.firewall_private_subnets[0])
  vpc_id = aws_vpc.firewall_vpc.id
  tags = merge(
    var.tags,
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

# Data & Management public route table
resource "aws_route_table" "fw_spb_rtb" { #fg2021
  vpc_id = aws_vpc.firewall_vpc.id
  tags = merge(
    var.tags,
    {
      "Name" = format("%s%s-%s-spb-rtb",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature,
      )
    }
  )
}

# HASync private route table
resource "aws_route_table" "fw_spv_02_rtb" { #fg2026
  vpc_id = aws_vpc.firewall_vpc.id
  tags = merge(
    var.tags,
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

# Routes

resource "aws_route" "spb_rtb_tgw_route" { #fg2021
  route_table_id         = aws_route_table.fw_spb_rtb.id
  destination_cidr_block = "10.210.0.0/16"
  transit_gateway_id     = local.transit_gateway_id
}

resource "aws_route" "spb_rtb_igw_route" { #fg2021
  route_table_id         = aws_route_table.fw_spb_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.firewall_igw.id
}

resource "aws_route" "spb_rtb_tgw_dmz_route" { #fg2021
  route_table_id         = aws_route_table.fw_spb_rtb.id
  destination_cidr_block = "172.210.0.0/16"
  transit_gateway_id     = local.transit_gateway_id
}

resource "aws_route" "rly_01_route" { #fg2034
  route_table_id         = aws_route_table.fw_spv_01_rtb[0].id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.eni-fgt1-data.id
}

resource "aws_route" "rly_02_route" { #fg2035
  route_table_id         = aws_route_table.fw_spv_01_rtb[1].id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.eni-fgt1-data.id
}

resource "aws_route" "spb_rtb_op_cidr_tgw_route" { #fg2021
  for_each = var.region == "eu-west-2" ? toset(module.globalvars.global.site_networks.emea) : var.region == "ap-southeast-1" ? toset(module.globalvars.global.site_networks.apac) : []
  route_table_id         = aws_route_table.fw_spb_rtb.id
  destination_cidr_block = each.value
  transit_gateway_id     = local.transit_gateway_id
}


# Subnets

resource "aws_subnet" "fw_spv_01" { #fg2008 #fg2009
  count                = length(local.firewall_private_subnets[0]) # 2
  vpc_id               = aws_vpc.firewall_vpc.id
  cidr_block           = local.firewall_private_subnets[0][count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null

  tags = merge(
    var.tags,
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

resource "aws_subnet" "fw_spv_02" { #fg2006 #fg2007
  count                = length(local.firewall_private_subnets[1]) # 2
  vpc_id               = aws_vpc.firewall_vpc.id
  cidr_block           = local.firewall_private_subnets[1][count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null

  tags = merge(
    var.tags,
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

resource "aws_subnet" "fw_spb_01" { #fg2004 #fg2005
  count                = length(local.firewall_public_subnets[0]) # 2
  vpc_id               = aws_vpc.firewall_vpc.id
  cidr_block           = local.firewall_public_subnets[0][count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null

  tags = merge(
    var.tags,
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

resource "aws_subnet" "fw_spb_02" { #fg2002 #fg2003
  count                = length(local.firewall_public_subnets[1]) # 2
  vpc_id               = aws_vpc.firewall_vpc.id
  cidr_block           = local.firewall_public_subnets[1][count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null

  tags = merge(
    var.tags,
    {
      "Name" = format("%s%s-%s-spb-0%d",
        local.nomenclature_1,
        substr(element(local.azs, count.index), -1, -1),
        local.firewall_nomenclature,
        2
      )
    }
  )
}

# Route Table Association
resource "aws_route_table_association" "fw_spv_01" { #fg2008 #fg2009 #fg2035
  count          = length(local.firewall_private_subnets[0]) # 2
  subnet_id      = element(aws_subnet.fw_spv_01[*].id, count.index)
  route_table_id = aws_route_table.fw_spv_01_rtb[count.index].id
}

resource "aws_route_table_association" "fw_spv_02" { #fg2006 #fg2007 #fg2026
  count          = length(local.firewall_private_subnets[1]) # 2
  subnet_id      = element(aws_subnet.fw_spv_02[*].id, count.index)
  route_table_id = aws_route_table.fw_spv_02_rtb.id
}

resource "aws_route_table_association" "fw_spb" { #fg2002 #fg2003 #fg2004 #fg2005 #fg2021
  count          = length(var.firewall_public_subnets) # 4
  subnet_id      = element(concat(aws_subnet.fw_spb_01[*].id, aws_subnet.fw_spb_02[*].id), count.index)
  route_table_id = aws_route_table.fw_spb_rtb.id
}

# Private Network ACLs
resource "aws_network_acl" "fw_spv_01_acl" { #fg2030
  vpc_id     = aws_vpc.firewall_vpc.id
  subnet_ids = toset(flatten([for subnet in aws_subnet.fw_spv_01 : subnet.id]))
  # Ingress (inbound) rule allowing all traffic from 0.0.0.0/0
  ingress {
    protocol   = "-1" # -1 means all protocols
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0   # Allow all ports
    rule_no    = 100 # Rule number, adjust as needed
  }

  # Egress (outbound) rule allowing all traffic to 0.0.0.0/0
  egress {
    protocol   = "-1" # -1 means all protocols
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0   # Allow all ports
    rule_no    = 100 # Rule number, adjust as needed
  }
  tags = merge(
    var.tags,
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

#***************************************************************************************************

resource "aws_network_acl" "fw_spv_02_acl" { #fg2025
  subnet_ids = toset(flatten([for subnet in aws_subnet.fw_spv_02 : subnet.id]))
  vpc_id     = aws_vpc.firewall_vpc.id
  # Ingress (inbound) rule allowing all traffic from 0.0.0.0/0
  ingress {
    protocol   = "-1" # -1 means all protocols
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0   # Allow all ports
    rule_no    = 100 # Rule number, adjust as needed
  }

  # Egress (outbound) rule allowing all traffic to 0.0.0.0/0
  egress {
    protocol   = "-1" # -1 means all protocols
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0   # Allow all ports
    rule_no    = 100 # Rule number, adjust as needed
  }
  tags = merge(
    var.tags,
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
resource "aws_network_acl" "fw_spb_acl" { #fg2020
  subnet_ids = toset(flatten([for subnet in concat(aws_subnet.fw_spb_01, aws_subnet.fw_spb_02) : subnet.id]))
  vpc_id     = aws_vpc.firewall_vpc.id
  # Ingress (inbound) rule allowing all traffic from 0.0.0.0/0
  ingress {
    protocol   = "-1" # -1 means all protocols
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0   # Allow all ports
    rule_no    = 100 # Rule number, adjust as needed
  }

  # Egress (outbound) rule allowing all traffic to 0.0.0.0/0
  egress {
    protocol   = "-1" # -1 means all protocols
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0   # Allow all ports
    rule_no    = 100 # Rule number, adjust as needed
  }
  tags = merge(
    var.tags,
    {
      "Name" = format("%s%s-%s-spb-acl",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature,
      )
    }
  )
}

# Attachment to TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-mgmt" {  #fg2031 #fg2032
  subnet_ids                                      = [aws_subnet.fw_spv_01[0].id, aws_subnet.fw_spv_01[1].id]
  transit_gateway_id                              = local.transit_gateway_id
  vpc_id                                          = aws_vpc.firewall_vpc.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = merge(
    var.tags,
    {
      "Name" = format("%s%s-%s-tgwa",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature
      )
    }
  )
}

module "gateway_vpc_fl" { #VPC flow logs referencing a global module and central s3 flow bucket
  source = "../../../modules/vpc-flow-logs"

  name = format("%s%s-%s-%s",
    local.nomenclature_1,
    "x",
    local.firewall_nomenclature,
    aws_vpc.firewall_vpc.id
  )

  vpc_id                       = aws_vpc.firewall_vpc.id
  s3_destination_arn           = data.terraform_remote_state.central_vpc_flow_logs.outputs.central_vpc_fl_bucket_arn
  create_local_flow_logs_store = true

  traffic_type = "ALL"

  tags = local.tags
}