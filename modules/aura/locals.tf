locals {
  aura_lc_name = join("-", [var.global_vars.global.naming_convention.product, join("", [var.common, "x"]), var.client_env,
    var.global_vars.global.naming_convention.AURA,
    var.global_vars.global.naming_convention.LAUNCH_CONFIGURATION
  ])

  aura_aza_name = join("-", [var.global_vars.global.naming_convention.product, join("", [var.common, "a"]), var.client_env,
    var.global_vars.global.naming_convention.WEB_SERVICE,
    var.global_vars.global.naming_convention.AURA,
    var.global_vars.global.naming_convention.EC2, "01"
  ])

  aura_azb_name = join("-", [var.global_vars.global.naming_convention.product, join("", [var.common, "b"]), var.client_env,
    var.global_vars.global.naming_convention.WEB_SERVICE,
    var.global_vars.global.naming_convention.AURA,
    var.global_vars.global.naming_convention.EC2, "02"
  ])

  aura_a_asg_name = join("-", [var.global_vars.global.naming_convention.product, join("", [var.common, "a"]), var.client_env,
    var.global_vars.global.naming_convention.AURA,
    var.global_vars.global.naming_convention.AUTOSCALING_GROUP, "01"
  ])

  aura_b_asg_name = join("-", [var.global_vars.global.naming_convention.product, join("", [var.common, "b"]), var.client_env,
    var.global_vars.global.naming_convention.AURA,
    var.global_vars.global.naming_convention.AUTOSCALING_GROUP, "02"
  ])

  aura_hostname = join("-", [var.client_env, var.global_vars.global.naming_convention.AURA])

  tags = merge(var.global_vars.global.tags, var.map_tags, {
    "Client Number" = var.client_id,
    "Service"       = var.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Product"       = var.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Component"     = "${var.global_vars.global.tagging_convention.service_tag.LENDSCAPE}-${var.global_vars.global.tagging_convention.component_tag.LSINTERNALWEBSERVERAURA}",
    "Tier"          = upper(replace(var.tier, "ier", "")),
    "Environment"   = "${var.global_vars.global.tagging_convention.service_tag.LENDSCAPE}${var.client_id}${var.env_domain}",
    "Domain"        = var.env_domain,
    "AssetID"       = "-",
    "BIA Risk"      = var.bia_risk,
    "CIA Risk"      = var.cia_risk,
    "Data Classification"   = var.data_classification


  })
}

