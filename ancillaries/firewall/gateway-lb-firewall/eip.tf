resource "aws_eip" "eth0_port1_aza" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.firewall_igw]
  tags = merge(
    var.tags,
    {
      "Name" = format("%s%s-%s-fg1-eipmgnt-01",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature
      )
    },
    local.tags
  )
}

resource "aws_eip_association" "eip_assoc_aza" {
  network_interface_id = aws_network_interface.eth0.id
  allocation_id        = aws_eip.eth0_port1_aza.id
}

resource "aws_eip" "eth0_port1_azb" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.firewall_igw]
  tags = merge(
    var.tags,
    {
      "Name" = format("%s%s-%s-fg1-eipmgnt-02",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature
      )
    },
    local.tags
  )
}

resource "aws_eip_association" "eip_assoc_azb" {
  network_interface_id = aws_network_interface.eth0_azb.id
  allocation_id        = aws_eip.eth0_port1_azb.id
}