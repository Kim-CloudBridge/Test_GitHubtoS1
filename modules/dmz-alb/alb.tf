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
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}