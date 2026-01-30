# Instances
resource "aws_instance" "core_01" {
  ami                    = var.environment.core_config.ami[var.environment.region]
  instance_type          = var.environment.core_config.instance_type[var.tier]
  iam_instance_profile   = var.ssm_instance_profile.name
  user_data              = templatefile("${path.module}/core-config/userdata.tpl", { hostname = local.core_hostname })

  network_interface {
    network_interface_id = aws_network_interface.core_01_primary_nic.id
    device_index         = 0
  }

  root_block_device {
    tags = merge({
      Name       = local.core_aza_name
      ADJoined   = "true"
      ReImported = true
      AutoManage = true
    }, local.tags
    )
  }

  tags = merge({
    Name       = local.core_aza_name
    ADJoined   = "true"
    ReImported = true
    AutoManage = true
  }, local.tags
  )
}
resource "aws_network_interface" "core_01_primary_nic" {
  subnet_id         = var.app_subnet_ids_array[0]
  security_groups   = [var.core_security_group_id, var.management_security_group_id, var.jenkins_sgp]
  private_ips_count = var.environment.core_config.number_of_secondary_ips

  tags = merge({
    Name = "${local.core_aza_name}-primary-nic"
  }, local.tags )
}
resource "aws_lb_target_group_attachment" "core_target_group_attachment_01_JMS" {
  target_group_arn = var.nlb_core_target_groups_arn[upper(var.global_vars.global.naming_convention.JMS)]
  target_id        = aws_instance.core_01.id
}
resource "aws_lb_target_group_attachment" "core_target_group_attachment_01_API" {
  target_group_arn = var.nlb_core_target_groups_arn[upper(var.global_vars.global.naming_convention.API)]
  target_id        = aws_instance.core_01.id
}
resource "aws_lb_target_group_attachment" "core_target_group_attachment_01_HAZELCAST" {
  target_group_arn = var.nlb_core_target_groups_arn[upper(var.global_vars.global.naming_convention.HAZELCAST)]
  target_id        = aws_instance.core_01.id
}

resource "aws_instance" "core_02" {
  ami                    = var.environment.core_config.ami[var.environment.region]
  instance_type          = var.environment.core_config.instance_type[var.tier]
  iam_instance_profile   = var.ssm_instance_profile.name
  user_data              = templatefile("${path.module}/core-config/userdata.tpl", { hostname = local.core_hostname })

  network_interface {
    network_interface_id = aws_network_interface.core_02_primary_nic.id
    device_index         = 0
  }

  root_block_device {
    tags = merge({
      Name       = local.core_azb_name
      ADJoined   = "true"
      ReImported = true
      AutoManage = true
    }, local.tags 
    )
  }

  tags = merge({
    Name       = local.core_azb_name
    ADJoined   = "true"
    ReImported = true
    AutoManage = true
  }, local.tags 
  )
}
resource "aws_network_interface" "core_02_primary_nic" {
  subnet_id         = var.app_subnet_ids_array[1]
  security_groups   = [var.core_security_group_id, var.management_security_group_id, var.jenkins_sgp]
  private_ips_count = var.environment.core_config.number_of_secondary_ips

  tags = merge({
    Name = "${local.core_azb_name}-primary-nic"
  }, local.tags)
}
resource "aws_lb_target_group_attachment" "core_target_group_attachment_02_JMS" {
  target_group_arn = var.nlb_core_target_groups_arn[upper(var.global_vars.global.naming_convention.JMS)]
  target_id        = aws_instance.core_02.id
}
resource "aws_lb_target_group_attachment" "core_target_group_attachment_02_API" {
  target_group_arn = var.nlb_core_target_groups_arn[upper(var.global_vars.global.naming_convention.API)]
  target_id        = aws_instance.core_02.id
}
resource "aws_lb_target_group_attachment" "core_target_group_attachment_02_HAZELCAST" {
  target_group_arn = var.nlb_core_target_groups_arn[upper(var.global_vars.global.naming_convention.HAZELCAST)]
  target_id        = aws_instance.core_02.id
}
