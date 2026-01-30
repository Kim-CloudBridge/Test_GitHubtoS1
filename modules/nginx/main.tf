# Instances
resource "aws_instance" "nginx_01" {
  ami                    = var.environment.nginx_config.ami[var.environment.region]
  instance_type          = var.environment.nginx_config.instance_type[var.tier]
  subnet_id              = var.public_subnet_ids_array[0]
  iam_instance_profile   = var.ssm_instance_profile.name
  user_data              = templatefile("${path.module}/nginx-config/userdata.tpl", { hostname = local.hostname })
  vpc_security_group_ids = [var.nginx_security_group_id]

  root_block_device {
    tags = merge({
        Name       = local.nginx_aza_name
        ADJoined   = "true"
        ReImported = true
        AutoManage = true
      },
      local.tags
    )
  }

  tags = merge({
      Name       = local.nginx_aza_name
      ADJoined   = "true"
      ReImported = true
      AutoManage = true
    },
    local.tags
  )
}
resource "aws_lb_target_group_attachment" "nginx_target_group_attachment_01" {
  target_group_arn = var.alb_target_group_arn
  target_id        = aws_instance.nginx_01.id
}
resource "aws_instance" "nginx_02" {
  ami                    = var.environment.nginx_config.ami[var.environment.region]
  instance_type          = var.environment.nginx_config.instance_type[var.tier]
  subnet_id              = var.public_subnet_ids_array[1]
  iam_instance_profile   = var.ssm_instance_profile.name
  user_data              = templatefile("${path.module}/nginx-config/userdata.tpl", { hostname = local.hostname })
  vpc_security_group_ids = [var.nginx_security_group_id]

  root_block_device {
    tags = merge({
        Name       = local.nginx_azb_name
        ADJoined   = "true"
        ReImported = true
        AutoManage = true
      },
      local.tags
    )
  }

  tags = merge({
      Name       = local.nginx_azb_name
      ADJoined   = "true"
      ReImported = true
      AutoManage = true
    },
    local.tags 
  )
}
resource "aws_lb_target_group_attachment" "nginx_target_group_attachment_02" {
  target_group_arn = var.alb_target_group_arn
  target_id        = aws_instance.nginx_02.id
}
