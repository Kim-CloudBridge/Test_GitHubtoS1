// Security Group
resource "aws_security_group" "management_ingress" { #fg1031
  count = length(var.management_ports)

  name = format("%s%s-%s-mgmt-ingress-sgp-0%d",
    local.nomenclature_1,
    "x",
    local.firewall_nomenclature,
    count.index
  )
  description = format("Management Allow traffic on port %d", var.management_ports[count.index])
  vpc_id      = aws_vpc.firewall_vpc.id

  ingress {
    from_port   = var.management_ports[count.index]
    to_port     = var.management_ports[count.index]
    protocol    = "6"
    cidr_blocks = local.management_ips
  }

  tags = merge(
    local.tags,
    {
      Name = format("%s%s-%s-mgmt-ingress-sgp-0%d",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature,
        count.index
      )
    }
  )
}


resource "aws_security_group" "public_allow" { #fg1032
  name = format("%s%s-%s-pub-sgp",
    local.nomenclature_1,
    "x",
    local.firewall_nomenclature
  )
  description = "Public Allow traffic"
  vpc_id      = aws_vpc.firewall_vpc.id

  # ingress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "6"
  #   cidr_blocks = flatten([
  #     module.globalvars.global["site_networks"]["eu-dc"],
  #     ["3.11.6.235/32"] # CB Tailscale
  #   ])
  # }

  # ingress {
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "6"
  #   cidr_blocks = flatten([
  #     module.globalvars.global["site_networks"]["eu-dc"],
  #     ["3.11.6.235/32"] # CB Tailscale
  #   ])
  # }

  # ingress {
  #   from_port   = 8443
  #   to_port     = 8443
  #   protocol    = "6"
  #   cidr_blocks = flatten([
  #     module.globalvars.global["site_networks"]["eu-dc"],
  #     ["3.11.6.235/32"] # CB Tailscale
  #   ])
  # }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.tags,
    {
      Name = format("%s%s-%s-pub-sgp",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature
      )
    }
  )
}

resource "aws_security_group" "allow_all" { #fg1033
  name = format("%s%s-%s-pvt-sgp",
    local.nomenclature_1,
    "x",
    local.firewall_nomenclature
  )
  description = "Allow all traffic"
  vpc_id      = aws_vpc.firewall_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.tags,
    {
      Name = format("%s%s-%s-pvt-sgp",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature
      )
    }
  )
}