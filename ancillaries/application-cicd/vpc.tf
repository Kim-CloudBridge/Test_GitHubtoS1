## To create AWS VPC
resource "aws_vpc" "main" {
  cidr_block = local.cicd_vpc.cidr


  tags = merge(
    {
      "Name" = format("%sx-%s-cicd-vpc",
        local.nomenclature_1,
        local.nomenclature_2
      )
    },
    local.tags,
  )
}

####################
## DHCP Options
####################

resource "aws_vpc_dhcp_options" "dhcp_option" {
  domain_name          = data.terraform_remote_state.managed_ad.outputs.managed_ad_dns_name
  domain_name_servers  = data.terraform_remote_state.managed_ad.outputs.managed_ad_ips
  # ntp_servers          = ["127.0.0.1"]
  # netbios_name_servers = ["127.0.0.1"]
  # netbios_node_type    = 2

  tags = merge(
    {
      "Name" = format("%sx-%s-cicd-vpc-dhcp",
        local.nomenclature_1,
        local.nomenclature_2
      )
    },
    local.tags,
  )
}

resource "aws_vpc_dhcp_options_association" "vpc_dhcp_assoc" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp_option.id
}


####################
## Subnets section
####################
resource "aws_subnet" "cicd_spv_01" {
  count                = length(local.cicd_vpc.private_subnets) # 2
  vpc_id               = aws_vpc.main.id
  cidr_block           = local.cicd_vpc.private_subnets[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null

  tags = merge(
    {
      "Name" = format("%s%s-%s-spv-0%d",
        local.nomenclature_1,
        substr(element(local.azs, count.index), -1, -1),
        local.nomenclature_2,
        1 + count.index
      )
    },
    local.tags
  )
}

resource "aws_subnet" "cicd_tgwa_01" {
  count                = length(local.cicd_vpc.tgw_subnets) # 2
  vpc_id               = aws_vpc.main.id
  cidr_block           = local.cicd_vpc.tgw_subnets[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null

  tags = merge(
    {
      "Name" = format("%s%s-%s-tgwa-0%d",
        local.nomenclature_1,
        substr(element(local.azs, count.index), -1, -1),
        local.nomenclature_2,
        1 + count.index
      )
    },
    local.tags
  )
}
###################
# TGW attachment section
###################
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach" {
  subnet_ids         = [aws_subnet.cicd_tgwa_01[0].id, aws_subnet.cicd_tgwa_01[1].id]
  transit_gateway_id = local.transit_gateway_id
  vpc_id             = aws_vpc.main.id

  tags = merge(
    {
      "Name" = format("%sx-%s-tgw-att-0%d",
        local.nomenclature_1,
        local.nomenclature_2,
        1
      )
    },
    local.tags,
  )
}
###################
# Route tables section
###################
resource "aws_route_table" "tgwa_subnet_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = local.transit_gateway_id
  }

  tags = merge(
    {
      "Name" = format("%sx-%s-tgwa-rtb-0%d",
        local.nomenclature_1,
        local.nomenclature_2,
        1
      )
    },
    local.tags,
  )
}

resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = local.transit_gateway_id
  }

  tags = merge(
    {
      "Name" = format("%sx-%s-private-rtb-0%d",
        local.nomenclature_1,
        local.nomenclature_2,
        1
      )
    },
    local.tags,
  )
}
###################
# Route table association section
###################
resource "aws_route_table_association" "tgwa_subnets" {
  count          = length(local.cicd_vpc.tgw_subnets)
  subnet_id      = element(aws_subnet.cicd_tgwa_01[*].id, count.index)
  route_table_id = aws_route_table.tgwa_subnet_route_table.id
}

resource "aws_route_table_association" "private_subnets" {
  count          = length(local.cicd_vpc.private_subnets)
  subnet_id      = element(aws_subnet.cicd_spv_01[*].id, count.index)
  route_table_id = aws_route_table.private_subnet_route_table.id
}

##################
# VPC Flow Logs
##################
module "vpc_fl" {
  source = "../../modules/vpc-flow-logs"

  name = format("%s%s-%s-%s",
    local.nomenclature_1,
    "x",
    local.nomenclature_2,
    aws_vpc.main.id
  )

  vpc_id                       = aws_vpc.main.id
  s3_destination_arn           = data.terraform_remote_state.central_vpc_flow_logs.outputs.central_vpc_fl_bucket_arn
  create_local_flow_logs_store = true

  traffic_type = "ALL"

  tags = local.tags
}