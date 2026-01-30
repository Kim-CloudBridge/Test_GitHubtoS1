resource "aws_subnet" "temporary_public_subnet" {
  vpc_id            = var.app_vpc.vpc_id
  cidr_block        = "10.210.50.192/28"
  availability_zone = local.azs[0]
}

resource "aws_internet_gateway" "temporary_internet_gateway" {
  vpc_id = var.app_vpc.vpc_id

  tags = {
    Name = "temporary_internet_gateway"
  }
}

resource "aws_route_table" "temporary_public" {
  vpc_id = var.app_vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.temporary_internet_gateway.id
  }

  tags = {
    Name = "temporary-public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.temporary_public_subnet.id
  route_table_id = aws_route_table.temporary_public.id
}

resource "aws_eip" "temporary_eip_nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "temporary_nat_gateway" {
  allocation_id = aws_eip.temporary_eip_nat.id
  subnet_id     = aws_subnet.temporary_public_subnet.id

  tags = {
    Name = "temporary-nat"
  }
}

resource "aws_route" "private_nat_route_1" {
  route_table_id         = var.app_vpc.app_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.temporary_nat_gateway.id
}

resource "aws_route" "private_nat_route_2" {
  route_table_id         = var.app_vpc.db_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.temporary_nat_gateway.id
}

resource "aws_security_group_rule" "egress_all_core" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = var.security_groups.core_security_group_id
}
resource "aws_security_group_rule" "egress_all_halo" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = var.security_groups.halo_security_group_id
}
resource "aws_security_group_rule" "egress_all_aura" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = var.security_groups.aura_security_group_id
}
resource "aws_security_group_rule" "egress_all_mdb" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = var.security_groups.mdb_security_group_id
}
resource "aws_security_group_rule" "egress_all_rdb" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = var.security_groups.rdb_security_group_id
}