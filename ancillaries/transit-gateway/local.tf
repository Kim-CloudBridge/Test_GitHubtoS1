locals {
  nomenclature_1 = "${module.globalvars.global.naming_convention.product}-${module.globalvars.global.naming_convention.regions[var.region]}"
  nomenclature_2 = "${var.hms_client_id}${var.hms_environment_id}"
  azs = [
    "${var.region}a",
    "${var.region}b",
  ]

  ram_shares_ou = [
    "arn:aws:organizations::070090186998:ou/o-acv6pn13sm/ou-l3ih-dh3v6zdv", # Customers
    "arn:aws:organizations::070090186998:ou/o-acv6pn13sm/ou-l3ih-u3ukyftf", # HMS
    "arn:aws:organizations::070090186998:ou/o-acv6pn13sm/ou-l3ih-1nbv4rbb", # Core
  ]

  tags = merge(
    module.globalvars.global.tags,
    var.common_tags
  )
}