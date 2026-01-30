# @TODO: Uncomment this code and main.tf#userdata in the launch configuration terraform resource when the FSx is ready
#        to be setup (AD is required)

resource "aws_fsx_windows_file_system" "fsx_for_core" {
 count = var.environment.core_config.create_fsx == true ? 1 : 0

 active_directory_id            = var.directory_id
 security_group_ids             = [var.gen_fsx_security_group_id, var.core_fsx_security_group_id]
 skip_final_backup              = true
 storage_capacity               = var.environment.core_config.fsx_storage_capacity
 subnet_ids                     = [var.fsx_subnet_id]
 throughput_capacity            = var.environment.core_config.fsx_throughput_capacity
 deployment_type                = var.environment.core_config.fsx_deployment_type
 storage_type                   = var.environment.core_config.fsx_storage_type
 weekly_maintenance_start_time  = "1:05:00"

 tags = merge({
   Name = local.core_fsx_name
 }, local.tags )
}