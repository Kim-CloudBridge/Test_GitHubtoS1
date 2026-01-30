locals {
  azs = [
    for az in var.environment.vpc.enabled_azs :
    "${var.environment.region}${az}"
  ]
}
