locals {
  nginx_tgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.PUBLIC_SERVICE,
    var.global_vars.global.naming_convention.TARGET_GROUP, "01"
  ])

  halo_tgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.HALO,
    var.global_vars.global.naming_convention.TARGET_GROUP
  ])

  aura_tgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.AURA,
    var.global_vars.global.naming_convention.TARGET_GROUP
  ])

  core_jms_tgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.CORE,
    var.global_vars.global.naming_convention.JMS,
    var.global_vars.global.naming_convention.TARGET_GROUP
  ])

  core_api_tgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.CORE,
    var.global_vars.global.naming_convention.API,
    var.global_vars.global.naming_convention.TARGET_GROUP
  ])

  core_hazelcast_tgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.CORE,
    var.global_vars.global.naming_convention.HAZELCAST,
    var.global_vars.global.naming_convention.TARGET_GROUP
  ])

  tags = merge(var.global_vars.global.tags, {
    "Client Number" = var.client_id,
    "Service"       = var.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Product"       = var.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Component"     = "${var.global_vars.global.tagging_convention.service_tag.LENDSCAPE}-TG",
    "Tier"          = upper(replace(var.tier, "ier", "")),
    "Environment"   = "${var.global_vars.global.tagging_convention.service_tag.LENDSCAPE}${var.client_id}${var.env_domain}",
    "Domain"        = var.env_domain
  })
}