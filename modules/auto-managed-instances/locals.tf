locals {
  lambda_exec_role_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.ROLE,
    var.global_vars.global.naming_convention.LAMBDA,
    var.global_vars.global.naming_convention.MANAGE-INSTANCES
  ])

  lambda_exec_policy_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.POLICY,
    var.global_vars.global.naming_convention.LAMBDA,
    var.global_vars.global.naming_convention.MANAGE-INSTANCES
  ])

  tags = merge(var.global_vars.global.tags, {
    "Client Number" = var.client_id,
    "Service"       = var.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Product"       = var.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Component"     = "${var.global_vars.global.tagging_convention.service_tag.LENDSCAPE}-LAMBDA",
    "Tier"          = upper(replace(var.tier, "ier", "")),
    "Environment"   = "${var.global_vars.global.tagging_convention.service_tag.LENDSCAPE}${var.client_id}${var.env_domain}",
    "Domain"        = var.env_domain
  })
}
