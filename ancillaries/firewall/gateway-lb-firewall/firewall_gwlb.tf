resource "aws_lb" "gateway_lb" { #fg1034
  name = format("%s%s-%s-gwlb",
    local.nomenclature_1,
    "x",
    local.firewall_nomenclature
  )
  load_balancer_type               = "gateway"
  enable_cross_zone_load_balancing = false

  // AZ1
  subnet_mapping {
    subnet_id = aws_subnet.fw_spv_02[0].id
  }

  // AZ2
  subnet_mapping {
    subnet_id = aws_subnet.fw_spv_02[1].id
  }

  tags = local.tags
}

resource "aws_lb_target_group" "fg1_target" { #fg1035
  name = format("%s%s-%s-tg",
    local.nomenclature_1,
    "x",
    local.firewall_nomenclature
  )
  port        = 6081
  protocol    = "GENEVE"
  target_type = "ip"
  vpc_id      = aws_vpc.firewall_vpc.id

  health_check {
    port     = 8008
    protocol = "TCP"
  }

  tags = local.tags
}

resource "aws_lb_listener" "fg1_listener" { #fg1036
  load_balancer_arn = aws_lb.gateway_lb.id

  default_action {
    target_group_arn = aws_lb_target_group.fg1_target.id
    type             = "forward"
  }

  tags = local.tags
}
resource "aws_vpc_endpoint_service" "fg1_gwlb_service" { #fg1010
  acceptance_required        = false
  gateway_load_balancer_arns = [aws_lb.gateway_lb.arn]
  tags = merge(
    local.tags,
    {
      Name = format("%s%s-%s-vpce-svc",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature
      )
    }
  )
}

resource "aws_lb_target_group_attachment" "fgt1Aattach" { #fg1026
  depends_on       = [aws_instance.fgtvm]
  target_group_arn = aws_lb_target_group.fg1_target.arn
  target_id        = data.aws_network_interface.eth1.private_ip
  port             = 6081
}

resource "aws_lb_target_group_attachment" "fgt1Battach" { #fg1029
  depends_on       = [aws_instance.fgtvm_azb]
  target_group_arn = aws_lb_target_group.fg1_target.arn
  target_id        = data.aws_network_interface.eth1_azb.private_ip
  port             = 6081
}