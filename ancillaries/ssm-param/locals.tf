locals {
  # Calculated attributes
  client_env    = join("", [var.client_id, var.env_suffix])
  common_prefix = join("", [module.global_vars.global.naming_convention.regions[var.region]])
  common_prefix_general_service = join("", [module.global_vars.global.naming_convention.regions[var.region],
  module.global_vars.global.naming_convention.GLOBAL_SERVICE])

  account_id = data.aws_caller_identity.current.account_id

  kms_name = join("-", [
    module.global_vars.global.naming_convention.product, local.common_prefix_general_service, local.client_env,
    module.global_vars.global.naming_convention.KMS, "ssm-params"
  ])

}

data "aws_caller_identity" "current" {}