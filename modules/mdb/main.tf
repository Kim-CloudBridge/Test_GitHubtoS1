# Instances
resource "aws_instance" "mdb_01" {
  ami                  = var.environment.mdb_config.ami[var.environment.region]
  instance_type        = var.environment.mdb_config.instance_type[var.tier]
  iam_instance_profile = var.ssm_instance_profile.name
  user_data            = templatefile("${path.module}/mdb-config/userdata.tpl", { hostname = local.mdb_hostname })

  network_interface {
    network_interface_id = aws_network_interface.mdb_01_primary_nic.id
    device_index         = 0
  }

  root_block_device {
    tags = merge({
      Name       = local.mdb_aza_name
      ADJoined   = "true"
      ReImported = true
      AutoManage = true
    }, local.tags)
  }

  tags = merge({
    Name       = local.mdb_aza_name
    ADJoined   = "true"
    ReImported = true
    AutoManage = true
  }, local.tags)
}
resource "aws_network_interface" "mdb_01_primary_nic" {
  subnet_id         = var.db_subnet_ids_array[0]
  security_groups   = [var.mdb_security_group_id, var.management_security_group_id, var.jenkins_sgp]
  private_ips_count = var.environment.mdb_config.number_of_secondary_ips

  tags = merge({
    Name = "${local.mdb_aza_name}-primary-nic"
  }, local.tags)
}


resource "aws_instance" "mdb_02" {
  ami                  = var.environment.mdb_config.ami[var.environment.region]
  instance_type        = var.environment.mdb_config.instance_type[var.tier]
  iam_instance_profile = var.ssm_instance_profile.name
  user_data            = templatefile("${path.module}/mdb-config/userdata.tpl", { hostname = local.mdb_hostname })

  network_interface {
    network_interface_id = aws_network_interface.mdb_02_primary_nic.id
    device_index         = 0
  }

  root_block_device {
    tags = merge({
      Name       = local.mdb_azb_name
      ADJoined   = "true"
      ReImported = true
      AutoManage = true
    }, local.tags)
  }

  tags = merge({
    Name       = local.mdb_azb_name
    ADJoined   = "true"
    ReImported = true
    AutoManage = true
  }, local.tags)
}
resource "aws_network_interface" "mdb_02_primary_nic" {
  subnet_id         = var.db_subnet_ids_array[1]
  security_groups   = [var.mdb_security_group_id, var.management_security_group_id, var.jenkins_sgp]
  private_ips_count = var.environment.mdb_config.number_of_secondary_ips

  tags = merge({
    Name = "${local.mdb_azb_name}-primary-nic"
  }, local.tags)
}