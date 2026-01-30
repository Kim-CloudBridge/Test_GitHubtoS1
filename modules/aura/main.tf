# Instances
resource "aws_instance" "aura_01" {
  ami                    = var.environment.aura_config.ami[var.environment.region]
  instance_type          = var.environment.aura_config.instance_type[var.tier]
  subnet_id              = var.app_subnet_ids_array[0]
  iam_instance_profile   = var.ssm_instance_profile.name
  user_data              = templatefile("${path.module}/aura-config/userdata.tpl", { hostname = local.aura_hostname })
  vpc_security_group_ids = [var.aura_security_group_id, var.management_security_group_id]

  root_block_device {
    tags = merge({
      Name              = local.aura_aza_name
      ADJoined          = "true"
      ReImported        = true
      AutoManageDelayed = true
    }, local.tags)
  }

  tags = merge({
    Name              = local.aura_aza_name
    ADJoined          = "true"
    ReImported        = true
    AutoManageDelayed = true
  }, local.tags)
}
resource "aws_lb_target_group_attachment" "aura_target_group_attachment_01" {
  target_group_arn = var.nlb_aura_target_group_arn
  target_id        = aws_instance.aura_01.id
}
resource "aws_instance" "aura_02" {
  ami                    = var.environment.aura_config.ami[var.environment.region]
  instance_type          = var.environment.aura_config.instance_type[var.tier]
  subnet_id              = var.app_subnet_ids_array[1]
  iam_instance_profile   = var.ssm_instance_profile.name
  user_data              = templatefile("${path.module}/aura-config/userdata.tpl", { hostname = local.aura_hostname })
  vpc_security_group_ids = [var.aura_security_group_id, var.management_security_group_id]

  root_block_device {
    tags = merge({
      Name              = local.aura_azb_name
      ADJoined          = "true"
      ReImported        = true
      AutoManageDelayed = true
    }, local.tags)
  }

  tags = merge({
    Name              = local.aura_azb_name
    ADJoined          = "true"
    ReImported        = true
    AutoManageDelayed = true
  }, local.tags)
}
resource "aws_lb_target_group_attachment" "aura_target_group_attachment_02" {
  target_group_arn = var.nlb_aura_target_group_arn
  target_id        = aws_instance.aura_02.id
}