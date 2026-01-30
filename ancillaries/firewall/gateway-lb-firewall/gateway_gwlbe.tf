resource "aws_vpc_endpoint" "gwlb_endpoint_fg1" { #fg1008
  count = length(local.gateway_private_subnets[0]) # 2

  service_name      = aws_vpc_endpoint_service.fg1_gwlb_service.service_name
  subnet_ids        = [aws_subnet.spv_02[count.index].id]
  vpc_endpoint_type = aws_vpc_endpoint_service.fg1_gwlb_service.service_type
  vpc_id            = aws_vpc.gateway_vpc.id

  tags = merge(
    local.tags,
    {
      Name = format("%s%s-%s-vpce-0%d",
        local.nomenclature_1,
        substr(element(local.azs, count.index), -1, -1),
        local.gateway_nomenclature,
        1
      )
    }
  )

  depends_on = [
    aws_subnet.spv_01
  ]
}


resource "aws_route" "spv_01_rtb_gwlbe_route" {
  count = length(local.gateway_private_subnets[0]) # 2
  route_table_id = element(
    aws_route_table.spv_01_rtb[*].id,
    count.index,
  )
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = aws_vpc_endpoint.gwlb_endpoint_fg1[count.index].id

  depends_on = [
    aws_vpc_endpoint.gwlb_endpoint_fg1,
    aws_route_table.spv_01_rtb
  ]
}
