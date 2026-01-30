locals {

  alb_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.PUBLIC_SERVICE,
    var.global_vars.global.naming_convention.ALB
  ])

  nginx_tgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.PUBLIC_SERVICE,
    var.global_vars.global.naming_convention.TARGET_GROUP, "01"
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
