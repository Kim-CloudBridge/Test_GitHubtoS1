locals {
  vpc_tag_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.DMZ,
    var.global_vars.global.naming_convention.VPC
  ])

  azs = [
    for az in var.environment.vpc.enabled_azs :
    "${var.environment.region}${az}"
  ]

  public_subnet_tags_per_az = {
    for az in local.azs :
    az => {
      Name = join("-", [var.global_vars.global.naming_convention.product,
        join("", [var.global_vars.global.naming_convention.regions[var.environment.region],
          substr(az, length(az) - 1, 1)
        ]),
        var.client_env, var.global_vars.global.naming_convention.DMZ,
        var.global_vars.global.naming_convention.SPB, "01"
      ]),
      Domain = var.env_domain
    }
  }

  intra_subnet_names = [
    for az in local.azs :
    join("-", [var.global_vars.global.naming_convention.product,
      join("", [var.global_vars.global.naming_convention.regions[var.environment.region],
        substr(az, length(az) - 1, 1)
      ]),
      var.client_env,
    var.global_vars.global.naming_convention.DMZ, var.global_vars.global.naming_convention.SPV, "01"])
  ]

  public_route_table_tags = merge({
    Name : join("-", [
      var.global_vars.global.naming_convention.product, var.common, var.client_env,
      var.global_vars.global.naming_convention.DMZ, var.global_vars.global.naming_convention.SPB,
      var.global_vars.global.naming_convention.ROUTE_TABLE
    ]),
  }, local.tags)

  intra_route_table_tags = merge({
    Name : join("-", [
      var.global_vars.global.naming_convention.product, var.common, var.client_env,
      var.global_vars.global.naming_convention.DMZ, var.global_vars.global.naming_convention.SPV,
    var.global_vars.global.naming_convention.ROUTE_TABLE]),
    Domain = var.env_domain
  }, local.tags)

  igw_tags = merge({
    Name : join("-", [
      var.global_vars.global.naming_convention.product, var.common, var.client_env,
      var.global_vars.global.naming_convention.DMZ, var.global_vars.global.naming_convention.INTERNET_GATEWAY
    ]),
    Domain = var.env_domain
  }, local.tags)

  public_acl_tags = merge({
    Name : join("-", [
      var.global_vars.global.naming_convention.product, var.common, var.client_env,
      var.global_vars.global.naming_convention.DMZ, var.global_vars.global.naming_convention.SPB,
      var.global_vars.global.naming_convention.ACL
    ]),
    Domain = var.env_domain
  }, local.tags)

  intra_acl_tags = merge({
    Name : join("-", [
      var.global_vars.global.naming_convention.product, var.common, var.client_env,
      var.global_vars.global.naming_convention.DMZ, var.global_vars.global.naming_convention.SPV,
      var.global_vars.global.naming_convention.ACL
    ]),
    Domain = var.env_domain
  }, local.tags)

  tgw_att_tags = merge({
    Name : join("-", [
      var.global_vars.global.naming_convention.product, var.common, var.client_env,
      var.global_vars.global.naming_convention.TGW_ATT, "DMZ", "02"
    ]),
  }, local.tags)

  tags = merge(var.global_vars.global.tags, {
    "Client Number" = var.client_id,
    "Service"       = var.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Product"       = var.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Component"     = "${var.global_vars.global.tagging_convention.service_tag.LENDSCAPE}-DMZ-VPC",
    "Tier"          = upper(replace(var.tier, "ier", "")),
    "Environment"   = "${var.global_vars.global.tagging_convention.service_tag.LENDSCAPE}${var.client_id}${var.env_domain}",
    "Domain"        = var.env_domain
  })
}
