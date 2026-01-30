data "aws_directory_service_directory" "my_domain_controller" {
  directory_id = var.ad_config.directory_id
}

resource "aws_fsx_ontap_file_system" "fsxn" {
  subnet_ids                = var.fsx_subnet_id
  preferred_subnet_id       = var.environment_fsxn_config.fsx_deployment_type == "MULTI_AZ_1" ? var.fsx_preferred_subnet_id : var.fsx_subnet_id[0]
  deployment_type           = var.environment_fsxn_config.fsx_deployment_type
  route_table_ids           = var.environment_fsxn_config.fsx_deployment_type == "MULTI_AZ_1" ? var.fsx_route_table_ids : null
  # endpoint_ip_address_range = var.environment_fsxn_config.endpoint_ip_range

  security_group_ids = [var.gen_fsx_security_group_id, var.fsx_security_group_id]



  storage_type        = var.environment_fsxn_config.storage_type
  storage_capacity    = var.environment_fsxn_config.storage_capacity
  throughput_capacity = var.environment_fsxn_config.throughput_capacity
  disk_iops_configuration {
    iops = var.environment_fsxn_config.disk_iops_configuration.iops
    mode = var.environment_fsxn_config.disk_iops_configuration.mode
  }

  weekly_maintenance_start_time = "1:05:00"

  tags = merge(
    { "Name" = local.fsx_name },
    local.tags
  )
}

resource "aws_fsx_ontap_storage_virtual_machine" "mdb_fsxn_svm" {
  file_system_id = aws_fsx_ontap_file_system.fsxn.id
  name           = join("-", [local.fsx_svm_name, "mdb"])

  root_volume_security_style = "NTFS"

  active_directory_configuration {
    netbios_name = join("-", [local.hostname, "mdb"])
    self_managed_active_directory_configuration {
      dns_ips                                = sort(data.aws_directory_service_directory.my_domain_controller.dns_ip_addresses)
      domain_name                            = upper(data.aws_directory_service_directory.my_domain_controller.name)
      password                               = var.ad_config.service_account_password
      username                               = var.ad_config.service_account_user
      file_system_administrators_group       = var.ad_config.file_system_administrators_group
      organizational_unit_distinguished_name = var.ad_config.organizational_unit_distinguished_name
    }
  }

  tags = local.tags
}

resource "aws_fsx_ontap_storage_virtual_machine" "rdb_fsxn_svm" {
  file_system_id = aws_fsx_ontap_file_system.fsxn.id
  name           = join("-", [local.fsx_svm_name, "rdb"])

  root_volume_security_style = "NTFS"

  active_directory_configuration {
    netbios_name = join("-", [local.hostname, "rdb"])
    self_managed_active_directory_configuration {
      dns_ips                                = sort(data.aws_directory_service_directory.my_domain_controller.dns_ip_addresses)
      domain_name                            = upper(data.aws_directory_service_directory.my_domain_controller.name)
      password                               = var.ad_config.service_account_password
      username                               = var.ad_config.service_account_user
      file_system_administrators_group       = var.ad_config.file_system_administrators_group
      organizational_unit_distinguished_name = var.ad_config.organizational_unit_distinguished_name
    }
  }

  tags = local.tags
}

resource "aws_fsx_ontap_storage_virtual_machine" "core_fsxn_svm" {
  file_system_id = aws_fsx_ontap_file_system.fsxn.id
  name           = join("-", [local.fsx_svm_name, "core"])

  root_volume_security_style = "NTFS"

  active_directory_configuration {
    netbios_name = join("-", [local.hostname, "core"])
    self_managed_active_directory_configuration {
      dns_ips                                = sort(data.aws_directory_service_directory.my_domain_controller.dns_ip_addresses)
      domain_name                            = upper(data.aws_directory_service_directory.my_domain_controller.name)
      password                               = var.ad_config.service_account_password
      username                               = var.ad_config.service_account_user
      file_system_administrators_group       = var.ad_config.file_system_administrators_group
      organizational_unit_distinguished_name = var.ad_config.organizational_unit_distinguished_name
    }
  }

  tags = local.tags
}

resource "aws_fsx_ontap_volume" "mdb_fsxn_volume" {
  name                       = join("_", [local.fsx_vol_name, "mdb"])
  junction_path              = "/vol1"
  size_in_megabytes          = var.environment_fsxn_config.volume_sizes.mdb
  storage_efficiency_enabled = true
  storage_virtual_machine_id = aws_fsx_ontap_storage_virtual_machine.mdb_fsxn_svm.id
  security_style             = "NTFS"
  skip_final_backup          = true

  tiering_policy {
    name           = "SNAPSHOT_ONLY"
    cooling_period = 2
  }

  # Can't configure a value for "ontap_volume_type": its value will be decided automatically based on the result of applying this configuration.
  # ontap_volume_type = local.environment_fsxn_config.ontap_volume_type

  # copy_tags_to_backups = true

  tags = local.tags
}

resource "aws_fsx_ontap_volume" "rdb_fsxn_volume" {
  name                       = join("_", [local.fsx_vol_name, "rdb"])
  junction_path              = "/vol1"
  size_in_megabytes          = var.environment_fsxn_config.volume_sizes.rdb
  storage_efficiency_enabled = true
  storage_virtual_machine_id = aws_fsx_ontap_storage_virtual_machine.rdb_fsxn_svm.id
  security_style             = "NTFS"
  skip_final_backup          = true

  tiering_policy {
    name           = "SNAPSHOT_ONLY"
    cooling_period = 2
  }

  tags = local.tags
}

resource "aws_fsx_ontap_volume" "core_fsxn_volume" {
  name                       = join("_", [local.fsx_vol_name, "core"])
  junction_path              = "/vol1"
  size_in_megabytes          = var.environment_fsxn_config.volume_sizes.core
  storage_efficiency_enabled = true
  storage_virtual_machine_id = aws_fsx_ontap_storage_virtual_machine.core_fsxn_svm.id
  security_style             = "NTFS"
  skip_final_backup          = true

  tiering_policy {
    name           = "SNAPSHOT_ONLY"
    cooling_period = 2
  }

  tags = local.tags
}

# #############
# #For New Self-Hosted AD
# ############
# #Need to active_directory_configuration values when self-hosted AD is setup 
# #Update this file to import tf state of the new self-hosted AD
# #Backup current SVM volumes then restore on the console
# #Import in terraform the restored volumes to the new SVM
# resource "aws_fsx_ontap_file_system" "self-hosted-fsxn" {
#   subnet_ids                = var.fsx_subnet_id
#   preferred_subnet_id       = var.environment_fsxn_config.fsx_deployment_type == "MULTI_AZ_1" ? var.fsx_preferred_subnet_id : var.fsx_subnet_id[0]
#   deployment_type           = var.environment_fsxn_config.fsx_deployment_type
#   route_table_ids           = var.environment_fsxn_config.fsx_deployment_type == "MULTI_AZ_1" ? var.fsx_route_table_ids : null
#   # endpoint_ip_address_range = var.environment_fsxn_config.endpoint_ip_range

#   security_group_ids = [var.gen_fsx_security_group_id, var.fsx_security_group_id]



#   storage_type        = var.environment_fsxn_config.storage_type
#   storage_capacity    = var.environment_fsxn_config.storage_capacity
#   throughput_capacity = var.environment_fsxn_config.throughput_capacity
#   disk_iops_configuration {
#     iops = var.environment_fsxn_config.disk_iops_configuration.iops
#     mode = var.environment_fsxn_config.disk_iops_configuration.mode
#   }

#   weekly_maintenance_start_time = "1:05:00"

#   tags = merge(
#     { "Name" = local.fsx_name },
#     local.tags
#   )
# }

# resource "aws_fsx_ontap_storage_virtual_machine" "self-hosted-mdb_fsxn_svm" {
#   file_system_id = aws_fsx_ontap_file_system.fsxn.id
#   name           = join("-", [local.fsx_svm_name, "mdb"])

#   root_volume_security_style = "NTFS"

#   active_directory_configuration {
#     netbios_name = join("-", [local.hostname, "mdb"])
#     self_managed_active_directory_configuration {
#       dns_ips                                = sort(data.aws_directory_service_directory.my_domain_controller.dns_ip_addresses)
#       domain_name                            = upper(data.aws_directory_service_directory.my_domain_controller.name)
#       password                               = var.ad_config.service_account_password
#       username                               = var.ad_config.service_account_user
#       file_system_administrators_group       = var.ad_config.file_system_administrators_group
#       organizational_unit_distinguished_name = var.ad_config.organizational_unit_distinguished_name
#     }
#   }

#   tags = local.tags
# }

# resource "aws_fsx_ontap_storage_virtual_machine" "self-hosted-rdb_fsxn_svm" {
#   file_system_id = aws_fsx_ontap_file_system.fsxn.id
#   name           = join("-", [local.fsx_svm_name, "rdb"])

#   root_volume_security_style = "NTFS"

#   active_directory_configuration {
#     netbios_name = join("-", [local.hostname, "rdb"])
#     self_managed_active_directory_configuration {
#       dns_ips                                = sort(data.aws_directory_service_directory.my_domain_controller.dns_ip_addresses)
#       domain_name                            = upper(data.aws_directory_service_directory.my_domain_controller.name)
#       password                               = var.ad_config.service_account_password
#       username                               = var.ad_config.service_account_user
#       file_system_administrators_group       = var.ad_config.file_system_administrators_group
#       organizational_unit_distinguished_name = var.ad_config.organizational_unit_distinguished_name
#     }
#   }

#   tags = local.tags
# }

# resource "aws_fsx_ontap_storage_virtual_machine" "self-hosted-core_fsxn_svm" {
#   file_system_id = aws_fsx_ontap_file_system.fsxn.id
#   name           = join("-", [local.fsx_svm_name, "core"])

#   root_volume_security_style = "NTFS"

#   active_directory_configuration {
#     netbios_name = join("-", [local.hostname, "core"])
#     self_managed_active_directory_configuration {
#       dns_ips                                = sort(data.aws_directory_service_directory.my_domain_controller.dns_ip_addresses)
#       domain_name                            = upper(data.aws_directory_service_directory.my_domain_controller.name)
#       password                               = var.ad_config.service_account_password
#       username                               = var.ad_config.service_account_user
#       file_system_administrators_group       = var.ad_config.file_system_administrators_group
#       organizational_unit_distinguished_name = var.ad_config.organizational_unit_distinguished_name
#     }
#   }

#   tags = local.tags
# }