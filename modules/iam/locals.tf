locals {
  assume_role_arn_exists = var.assume_role_arn != null
  
  ssm_role_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.ROLE,
    var.global_vars.global.naming_convention.SSM
  ])

  cicd_assume_role_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.ROLE,
    var.global_vars.global.naming_convention.CICD, "assume-role"
  ])

  secrets_manager_policy_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.POLICY,
    var.global_vars.global.naming_convention.SSM, "get-secrets"
  ])

  kms_grant_policy_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.POLICY,
    var.global_vars.global.naming_convention.SSM, "kms-grant"
  ])

  ec2_read_policy_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.POLICY,
    var.global_vars.global.naming_convention.SSM, "ec2-read"
  ])

  fsx_read_policy_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.POLICY,
    var.global_vars.global.naming_convention.SSM, "fsx-read"
  ])

  assume_role_policy_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.POLICY,
    var.global_vars.global.naming_convention.SSM, "assume-role"
  ])

  ssm_instance_profile_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.INSTANCE_PROFILE,
    var.global_vars.global.naming_convention.SSM
  ])

  tags = merge(var.global_vars.global.tags, {
    "Client Number" = var.client_id,
    "Service"       = var.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Product"       = var.global_vars.global.tagging_convention.service_tag.LENDSCAPE,
    "Component"     = "${var.global_vars.global.tagging_convention.service_tag.LENDSCAPE}-IAM",
    "Tier"          = upper(replace(var.tier, "ier", "")),
    "Environment"   = "${var.global_vars.global.tagging_convention.service_tag.LENDSCAPE}${var.client_id}${var.env_domain}",
    "Domain"        = var.env_domain
  })
}
