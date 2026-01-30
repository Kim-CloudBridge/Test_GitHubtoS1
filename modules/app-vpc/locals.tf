locals {
  vpc_tag_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.APP,
    var.global_vars.global.naming_convention.VPC
  ])

  azs = [
    for az in var.environment.vpc.enabled_azs :
    "${var.environment.region}${az}"
  ]

  application_subnet_names = [
    for az in local.azs :
    join("-", [var.global_vars.global.naming_convention.product,
      join("", [var.global_vars.global.naming_convention.regions[var.environment.region],
        substr(az, length(az) - 1, 1)
      ]),
      var.client_env,
      var.global_vars.global.naming_convention.APP,
    var.global_vars.global.naming_convention.SPV, "03"])
  ]

  dbs_subnet_names = [
    for az in local.azs :
    join("-", [var.global_vars.global.naming_convention.product,
      join("", [var.global_vars.global.naming_convention.regions[var.environment.region],
        substr(az, length(az) - 1, 1)
      ]),
      var.client_env,
      var.global_vars.global.naming_convention.APP,
    var.global_vars.global.naming_convention.SPV, "02"])
  ]

  intra_subnet_names = [
    for az in local.azs :
    join("-", [var.global_vars.global.naming_convention.product,
      join("", [var.global_vars.global.naming_convention.regions[var.environment.region],
        substr(az, length(az) - 1, 1)
      ]),
      var.client_env,
      var.global_vars.global.naming_convention.APP,
    var.global_vars.global.naming_convention.SPV, "01"])
  ]

  intra_route_table_tags = merge({
    Name : join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
      var.global_vars.global.naming_convention.APP,
    var.global_vars.global.naming_convention.SPV, var.global_vars.global.naming_convention.ROUTE_TABLE, "01"]),
  }, local.tags)

  intra_acl_tags = merge({
    Name : join("-", [
      var.global_vars.global.naming_convention.product, var.common, var.client_env,
      var.global_vars.global.naming_convention.APP, var.global_vars.global.naming_convention.SPV,
      var.global_vars.global.naming_convention.ACL, "01"
    ])
  }, local.tags)

  application_route_table_tags = merge({
    Name : join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
      var.global_vars.global.naming_convention.APP, var.global_vars.global.naming_convention.SPV,
    var.global_vars.global.naming_convention.ROUTE_TABLE, "03"])
  }, local.tags)

  application_acl_tags = merge({
    Name : join("-", [
      var.global_vars.global.naming_convention.product, var.common, var.client_env,
      var.global_vars.global.naming_convention.APP, var.global_vars.global.naming_convention.SPV,
      var.global_vars.global.naming_convention.ACL, "03"
    ])
  }, local.tags)

  dbs_route_table_tags = merge({
    Name : join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
      var.global_vars.global.naming_convention.APP, var.global_vars.global.naming_convention.SPV,
    var.global_vars.global.naming_convention.ROUTE_TABLE, "02"])
  }, local.tags)

  db_acl_tags = merge({
    Name : join("-", [
      var.global_vars.global.naming_convention.product, var.common, var.client_env,
      var.global_vars.global.naming_convention.APP, var.global_vars.global.naming_convention.SPV,
      var.global_vars.global.naming_convention.ACL, "02"
    ])
  }, local.tags)

  vpce_tags = merge({
    Name : join("-", [
      var.global_vars.global.naming_convention.product, var.common, var.client_env,
      var.global_vars.global.naming_convention.APP, var.global_vars.global.naming_convention.SPV,
      var.global_vars.global.naming_convention.VPCE
    ])
  }, local.tags)

  tgw_att_tags = merge({
    Name : join("-", [
      var.global_vars.global.naming_convention.product, var.common, var.client_env,
      var.global_vars.global.naming_convention.TGW_ATT, "01"
    ])
  }, local.tags)

  tags = merge(var.global_vars.global.tags, {
    "Client Number" = var.client_id,
    "Service"       = var.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Product"       = var.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Component"     = "${var.global_vars.global.tagging_convention.service_tag.LENDSCAPE}-APP-VPC",
    "Tier"          = upper(replace(var.tier, "ier", "")),
    "Environment"   = "${var.global_vars.global.tagging_convention.service_tag.LENDSCAPE}${var.client_id}${var.env_domain}",
    "Domain"        = var.env_domain
  })
}
