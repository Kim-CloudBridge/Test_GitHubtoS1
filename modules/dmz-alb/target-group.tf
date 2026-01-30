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