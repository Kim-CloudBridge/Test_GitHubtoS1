locals {
  alb_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.PUBLIC_SERVICE,
    var.global_vars.global.naming_convention.ALB
  ])

  nlb_halo_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.HALO,
    var.global_vars.global.naming_convention.NLB
  ])

  nlb_aura_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.AURA,
    var.global_vars.global.naming_convention.NLB
  ])

  nlb_core_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.CORE,
    var.global_vars.global.naming_convention.NLB
  ])

  tags = merge(var.global_vars.global.tags, var.map_tags, {
    "Client Number" = var.client_id,
    "Service"       = var.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Product"       = var.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Component"     = "${var.global_vars.global.tagging_convention.service_tag.LENDSCAPE}-LBS",
    "Tier"          = upper(replace(var.tier, "ier", "")),
    "Environment"   = "${var.global_vars.global.tagging_convention.service_tag.LENDSCAPE}${var.client_id}${var.env_domain}",
    "Domain"        = var.env_domain
  })
}