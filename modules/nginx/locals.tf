locals {
  nginx_lc_name = join("-", [var.global_vars.global.naming_convention.product, join("", [var.common, "x"]), var.client_env,
    var.global_vars.global.naming_convention.NGINX,
    var.global_vars.global.naming_convention.LAUNCH_CONFIGURATION
  ])

  nginx_aza_name = join("-", [var.global_vars.global.naming_convention.product, join("", [var.common, "a"]), var.client_env,
    var.global_vars.global.naming_convention.NGINX,
    var.global_vars.global.naming_convention.EC2, "01"
  ])

  nginx_azb_name = join("-", [var.global_vars.global.naming_convention.product, join("", [var.common, "b"]), var.client_env,
    var.global_vars.global.naming_convention.NGINX,
    var.global_vars.global.naming_convention.EC2, "02"
  ])

  nginx_a_asg_name = join("-", [var.global_vars.global.naming_convention.product, join("", [var.common, "a"]), var.client_env,
    var.global_vars.global.naming_convention.NGINX,
    var.global_vars.global.naming_convention.AUTOSCALING_GROUP, "01"
  ])

  nginx_b_asg_name = join("-", [var.global_vars.global.naming_convention.product, join("", [var.common, "b"]), var.client_env,
    var.global_vars.global.naming_convention.NGINX,
    var.global_vars.global.naming_convention.AUTOSCALING_GROUP, "02"
  ])

  hostname = join("-", [var.client_env, var.global_vars.global.naming_convention.NGINX])

  tags = merge(var.global_vars.global.tags, {
    "Client Number" = var.client_id,
    "Service"       = var.global_vars.global.tagging_convention.service_tag.NGINX,
    "Product"       = var.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Component"     = "${var.global_vars.global.tagging_convention.service_tag.LENDSCAPE}-WEB-${var.global_vars.global.tagging_convention.service_tag.NGINX}",
    "Tier"          = upper(replace(var.tier, "ier", "")),
    "Environment"   = "${var.global_vars.global.tagging_convention.service_tag.LENDSCAPE}${var.client_id}${var.env_domain}",
    "Domain"        = var.env_domain,
    "AssetID"       = "-",
    "BIA Risk"      = var.bia_risk,
    "CIA Risk"      = var.cia_risk,
    "Data Classification"   = var.data_classification
  })
}