# @TODO HTTPs, ports, TLS and Certificates
#alb
resource "aws_lb" "alb" {
  name                       = local.alb_name
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.alb_security_group_id]
  subnets                    = var.public_subnet_ids_array
  enable_deletion_protection = false
  enable_http2               = true

  tags = merge({
    Name = local.alb_name
  }, local.tags)
}
resource "aws_lb_listener" "alb_public_https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  #port              = "443"
  #protocol          = "HTTPS"
  #ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01" # Enforces TLS 1.2
  # certificate_arn   = "arn:aws:iam::123456789012:server-certificate/certName" # We need the certificate
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "403 Forbidden"
      status_code  = "403"
    }
  }
}
resource "aws_lb_listener_rule" "alb_listener_rule" {
  listener_arn = aws_lb_listener.alb_public_https_listener.arn
  action {
    type             = "forward"
    target_group_arn = var.alb_target_group_arn
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

#LB for APP
#nlb_halo
resource "aws_lb" "nlb_halo" {
  name                             = local.nlb_halo_name
  internal                         = true
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = true
  subnets                          = var.app_subnet_ids_array
  security_groups                  = [var.nlb_halo_security_group_id]
  enable_deletion_protection       = false

  access_logs {
    bucket  = "halo-nlb-access-logs"
    enabled = true
  }
  tags = merge({
    Name = local.nlb_halo_name
  }, local.tags)
}
resource "aws_lb_listener" "nlb_halo_listener" {
  load_balancer_arn = aws_lb.nlb_halo.arn
  port              = "8081"
  protocol          = "TCP"
  #protocol          = "TLS"
  # Enforcing the use of TLS 1.2
  #ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  # Specify your SSL certificate ARN. You can use an ACM certificate.
  #certificate_arn   = "arn:aws:acm:region:account-id:certificate/certificate-id"
  default_action {
    type             = "forward"
    target_group_arn = var.nlb_halo_target_group_arn
  }
}

#nlb_aura
resource "aws_lb" "nlb_aura" {
  name                             = local.nlb_aura_name
  internal                         = true
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = false
  subnets                          = var.app_subnet_ids_array
  security_groups                  = [var.nlb_aura_security_group_id]
  enable_deletion_protection       = false

  tags = merge({
    Name = local.nlb_aura_name
  }, local.tags)
}
resource "aws_lb_listener" "nlb_aura_listener" {
  load_balancer_arn = aws_lb.nlb_aura.arn
  port              = "8081"
  protocol          = "TCP"
  #protocol          = "TLS"
  # Enforcing the use of TLS 1.2
  #ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  # Specify your SSL certificate ARN. You can use an ACM certificate.
  #certificate_arn   = "arn:aws:acm:region:account-id:certificate/certificate-id"
  default_action {
    type             = "forward"
    target_group_arn = var.nlb_aura_target_group_arn
  }
}

#nlb_core
resource "aws_lb" "nlb_core" {
  name                             = local.nlb_core_name
  internal                         = true
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = false
  subnets                          = var.app_subnet_ids_array
  security_groups                  = [var.nlb_core_security_group_id]
  enable_deletion_protection       = false

  tags = merge({
    Name = local.nlb_core_name
  }, local.tags)
}
resource "aws_lb_listener" "nlb_core_jms_listener" {
  load_balancer_arn = aws_lb.nlb_core.arn
  port              = "61616"
  protocol          = "TCP"
  #protocol          = "TLS"
  # Enforcing the use of TLS 1.2
  #ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  # Specify your SSL certificate ARN. You can use an ACM certificate.
  #certificate_arn   = "arn:aws:acm:region:account-id:certificate/certificate-id"
  default_action {
    type             = "forward"
    target_group_arn = var.nlb_core_targets_group_arn["JMS"]
  }
}
resource "aws_lb_listener" "nlb_core_api_listener" {
  load_balancer_arn = aws_lb.nlb_core.arn
  port              = "8085"
  protocol          = "TCP"
  #protocol          = "TLS"
  # Enforcing the use of TLS 1.2
  #ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  # Specify your SSL certificate ARN. You can use an ACM certificate.
  #certificate_arn   = "arn:aws:acm:region:account-id:certificate/certificate-id"
  default_action {
    type             = "forward"
    target_group_arn = var.nlb_core_targets_group_arn["API"]
  }
}
resource "aws_lb_listener" "nlb_core_hazelcast_listener" {
  load_balancer_arn = aws_lb.nlb_core.arn
  port              = "5701"
  protocol          = "TCP"
  #protocol          = "TLS"
  # Enforcing the use of TLS 1.2
  #ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  # Specify your SSL certificate ARN. You can use an ACM certificate.
  #certificate_arn   = "arn:aws:acm:region:account-id:certificate/certificate-id"
  default_action {
    type             = "forward"
    target_group_arn = var.nlb_core_targets_group_arn["HAZELCAST"]
  }
}