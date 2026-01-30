# Instances
resource "aws_instance" "rdb_01" {
  ami                    = var.environment.rdb_config.ami[var.environment.region]
  instance_type          = var.environment.rdb_config.instance_type[var.tier]
  iam_instance_profile   = var.ssm_instance_profile.name
  user_data              = templatefile("${path.module}/rdb-config/userdata.tpl", { hostname = local.rdb_hostname })

  network_interface {
    network_interface_id = aws_network_interface.rdb_01_primary_nic.id
    device_index         = 0
  }

  root_block_device {
    tags = merge({
      Name       = local.rdb_aza_name
      ADJoined   = "true"
      ReImported = true
      AutoManage = true
    }, local.tags)
  }

  tags = merge({
    Name       = local.rdb_aza_name
    ADJoined   = "true"
    ReImported = true
    AutoManage = true
  }, local.tags)
}
resource "aws_network_interface" "rdb_01_primary_nic" {
  subnet_id         = var.db_subnet_ids_array[0]
  security_groups   = [var.rdb_security_group_id, var.management_security_group_id, var.jenkins_sgp]
  private_ips_count = var.environment.rdb_config.number_of_secondary_ips

  tags = merge({
    Name = "${local.rdb_aza_name}-primary-nic"
  }, local.tags)
}

resource "aws_instance" "rdb_02" {
  ami                    = var.environment.rdb_config.ami[var.environment.region]
  instance_type          = var.environment.rdb_config.instance_type[var.tier]
  iam_instance_profile   = var.ssm_instance_profile.name
  user_data              = templatefile("${path.module}/rdb-config/userdata.tpl", { hostname = local.rdb_hostname })

  network_interface {
    network_interface_id = aws_network_interface.rdb_02_primary_nic.id
    device_index         = 0
  }

  root_block_device {
    tags = merge({
      Name       = local.rdb_azb_name
      ADJoined   = "true"
      ReImported = true
      AutoManage = true
    }, local.tags)
  }

  tags = merge({
    Name       = local.rdb_azb_name
    ADJoined   = "true"
    ReImported = true
    AutoManage = true
  }, local.tags)
}
resource "aws_network_interface" "rdb_02_primary_nic" {
  subnet_id         = var.db_subnet_ids_array[1]
  security_groups   = [var.rdb_security_group_id, var.management_security_group_id, var.jenkins_sgp]
  private_ips_count = var.environment.rdb_config.number_of_secondary_ips

  tags = merge({
    Name = "${local.rdb_azb_name}-primary-nic"
  }, local.tags)
}
