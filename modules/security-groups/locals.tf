locals {
  alb_sgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.PUBLIC_SERVICE,
    var.global_vars.global.naming_convention.ALB, var.global_vars.global.naming_convention.SECURITY_GROUP
  ])

  nginx_sgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.NGINX,
    var.global_vars.global.naming_convention.SECURITY_GROUP
  ])

  nlb_halo_sgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.HALO,
    var.global_vars.global.naming_convention.NLB, var.global_vars.global.naming_convention.SECURITY_GROUP
  ])

  halo_sgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.HALO,
    var.global_vars.global.naming_convention.SECURITY_GROUP
  ])

  nlb_aura_sgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.AURA,
    var.global_vars.global.naming_convention.NLB, var.global_vars.global.naming_convention.SECURITY_GROUP
  ])

  aura_sgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.AURA,
    var.global_vars.global.naming_convention.SECURITY_GROUP
  ])

  nlb_core_sgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.CORE,
    var.global_vars.global.naming_convention.NLB, var.global_vars.global.naming_convention.SECURITY_GROUP
  ])

  core_sgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.CORE,
    var.global_vars.global.naming_convention.SECURITY_GROUP
  ])

  mdb_sgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.MDB,
    var.global_vars.global.naming_convention.SECURITY_GROUP
  ])

  rdb_sgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.RDB,
    var.global_vars.global.naming_convention.SECURITY_GROUP
  ])

  management_sgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.SVC_CORP_ACCESS,
    var.global_vars.global.naming_convention.SECURITY_GROUP
  ])

  fsx_sgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.FSX,
    var.global_vars.global.naming_convention.SECURITY_GROUP
  ])

  mdb_fsx_sgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.MDB,
    var.global_vars.global.naming_convention.FSX,
    var.global_vars.global.naming_convention.SECURITY_GROUP
  ])

  rdb_fsx_sgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.RDB,
    var.global_vars.global.naming_convention.FSX,
    var.global_vars.global.naming_convention.SECURITY_GROUP
  ])

  core_fsx_sgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.CORE,
    var.global_vars.global.naming_convention.FSX,
    var.global_vars.global.naming_convention.SECURITY_GROUP
  ])

  appstream_sgp_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.APPSTREAM,
    var.global_vars.global.naming_convention.SECURITY_GROUP
  ])

  tags = merge(var.global_vars.global.tags, {
    "Client Number" = var.client_id,
    "Service"       = var.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Product"       = var.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Component"     = "${var.global_vars.global.tagging_convention.service_tag.LENDSCAPE}-SG",
    "Tier"          = upper(replace(var.tier, "ier", "")),
    "Environment"   = "${var.global_vars.global.tagging_convention.service_tag.LENDSCAPE}${var.client_id}${var.env_domain}",
    "Domain"        = var.env_domain
  })
}