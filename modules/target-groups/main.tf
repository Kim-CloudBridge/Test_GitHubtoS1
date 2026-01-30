# DMZ Target Groups
#tg_alb
resource "aws_alb_target_group" "alb_target_group" {
  name     = local.nginx_tgp_name
  port     = 8085
  protocol = "HTTP"
  vpc_id   = var.dmz_vpc.vpc_id
  stickiness {
    type            = "lb_cookie"
    enabled         = true
    cookie_duration = 300
  }
  health_check {
    enabled             = true
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/"
    port                = "8085"
  }

  tags = merge({
    Name = local.nginx_tgp_name
  }, local.tags)
}

# Application and DB Target Groups
#tg_halo
resource "aws_lb_target_group" "halo_target_group" {
  name     = local.halo_tgp_name
  port     = 8081
  protocol = "TCP"
  vpc_id   = var.app_vpc.vpc_id

  tags = merge({
    Name = local.halo_tgp_name
  }, local.tags)
}

#tg_aura
resource "aws_lb_target_group" "aura_target_group" {
  name     = local.aura_tgp_name
  port     = 8081
  protocol = "TCP"
  vpc_id   = var.app_vpc.vpc_id

  tags = merge({
    Name = local.aura_tgp_name
  }, local.tags)
}

#tg_core
resource "aws_lb_target_group" "core_jms_target_group" {
  name               = local.core_jms_tgp_name
  port               = 61616
  protocol           = "TCP"
  vpc_id             = var.app_vpc.vpc_id
  preserve_client_ip = false

  tags = merge({
    Name = local.core_jms_tgp_name
  }, local.tags)
}
resource "aws_lb_target_group" "core_api_target_group" {
  name     = local.core_api_tgp_name
  port     = 8085
  protocol = "TCP"
  vpc_id   = var.app_vpc.vpc_id

  tags = merge({
    Name = local.core_api_tgp_name
  }, local.tags)
}
resource "aws_lb_target_group" "core_hazelcast_target_group" {
  name     = local.core_hazelcast_tgp_name
  port     = 5701
  protocol = "TCP"
  vpc_id   = var.app_vpc.vpc_id

  tags = merge({
    Name = local.core_hazelcast_tgp_name
  }, local.tags)
}
