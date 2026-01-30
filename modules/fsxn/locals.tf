locals {

  az_placement = var.environment_fsxn_config.fsx_deployment_type == "SINGLE_AZ_1" ? substr(data.aws_subnet.fsx_subnet[0].availability_zone, length(data.aws_subnet.fsx_subnet[0].availability_zone) - 1, 1) : "x"

  fsx_name = join("-", [var.global_vars.global.naming_convention.product, join("", [var.common, local.az_placement]), var.client_env,
    var.global_vars.global.naming_convention.FSXN
  ])

  fsx_svm_name = join("-", [var.global_vars.global.naming_convention.product, join("", [var.common, local.az_placement]), var.client_env,
    var.global_vars.global.naming_convention.FSXN, var.global_vars.global.naming_convention.SVM
  ])

  fsx_vol_name = join("_", [var.global_vars.global.naming_convention.product, join("", [var.common, local.az_placement]), var.client_env,
    var.global_vars.global.naming_convention.FSXN, var.global_vars.global.naming_convention.VOLUME
  ])

  hostname = upper(join("-", [var.client_env, var.global_vars.global.naming_convention.FSXN]))

  environment_fsxn_config = {
    fsx_deployment_type = "SINGLE_AZ_1"
    storage_type        = "SSD"
    storage_capacity    = "1024"
    throughput_capacity = "128"
    # endpoint_ip_range   = "10.210.50.64/26"
    disk_iops_configuration = {
      iops = "40000"
      mode = "USER_PROVISIONED"
    }
    ontap_volume_type = "RW"
  }

  tags = merge(var.global_vars.global.tags, var.map_tags, {
    "Client Number" = var.client_id,
    "Service"       = var.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Product"       = var.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Component"     = "${var.global_vars.global.tagging_convention.service_tag.LENDSCAPE}",
    "Tier"          = upper(replace(var.tier, "ier", "")),
    "Environment"   = "${var.global_vars.global.tagging_convention.service_tag.LENDSCAPE}${var.client_id}${var.env_domain}",
    "Domain"        = var.env_domain
  })
}