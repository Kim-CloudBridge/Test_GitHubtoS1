## To create AWS VPC
resource "aws_vpc" "main" {
  cidr_block = var.shared_svcs_vpc_cidr

  tags = merge(
    {
      "Name" = format("%sx-%s-shared-vpc",
        local.nomenclature_1,
        local.nomenclature_2
      )
    },
    local.tags,
  )
}
####################
## Subnets section
####################
resource "aws_subnet" "shared_spv_01" {
  count                = length(local.private_subnets[0]) # 2
  vpc_id               = aws_vpc.main.id
  cidr_block           = local.private_subnets[0][count.index]
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

resource "aws_subnet" "shared_spb_01" {
  count                = length(local.public_subnets[0]) # 2
  vpc_id               = aws_vpc.main.id
  cidr_block           = local.public_subnets[0][count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null

  tags = merge(
    {
      "Name" = format("%s%s-%s-spb-0%d",
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
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach" { #ad1002
  subnet_ids         = [aws_subnet.shared_spv_01[0].id, aws_subnet.shared_spv_01[1].id]
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
resource "aws_route_table" "public_subnet_route_table" { #ad1003
  vpc_id = aws_vpc.main.id

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = local.transit_gateway_id
  }

  tags = merge(
    {
      "Name" = format("%sx-%s-public-rtb-0%d",
        local.nomenclature_1,
        local.nomenclature_2,
        1
      )
    },
    local.tags,
  )
}

resource "aws_route_table" "private_subnet_route_table" { #ad1004
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
resource "aws_route_table_association" "public_subnets" {
  count          = length(local.private_subnets[0])
  subnet_id      = element(aws_subnet.shared_spb_01[*].id, count.index)
  route_table_id = aws_route_table.public_subnet_route_table.id
}

resource "aws_route_table_association" "private_subnets" {
  count          = length(local.private_subnets[0])
  subnet_id      = element(aws_subnet.shared_spv_01[*].id, count.index)
  route_table_id = aws_route_table.private_subnet_route_table.id
}