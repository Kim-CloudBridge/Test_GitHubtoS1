locals {
  lambda_function_code = templatefile("${path.module}/lambda/index.js.tpl", {
    cdn_domain = aws_cloudfront_distribution.website_cdn.domain_name
    fleet_name = aws_appstream_fleet.fleet_desktop.name
    stack_name = aws_appstream_stack.stack.name
  })

  appstream_bucket_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.APPSTREAM,
    var.global_vars.global.naming_convention.S3
  ])

  saas_portal_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.SAAS
  ])

  email_sending_account_type = "DEVELOPER" # Or 'COGNITO_DEFAULT'

  fleet_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.APPSTREAM,
    var.global_vars.global.naming_convention.FLEET
  ])

  stack_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.APPSTREAM,
    var.global_vars.global.naming_convention.STACK
  ])

  lambda_saas_function_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.LAMBDA,
    var.global_vars.global.naming_convention.SAAS
  ])

  saas_api_gateway_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.APIGATEWAY,
    var.global_vars.global.naming_convention.SAAS
  ])

  saas_api_gateway_description = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.APIGATEWAY,
    var.global_vars.global.naming_convention.SAAS, " description"
  ])

  authorizer_name = join("-", [var.global_vars.global.naming_convention.product, var.common, var.client_env,
    var.global_vars.global.naming_convention.APIGATEWAY,
    var.global_vars.global.naming_convention.SAAS, "auth"
  ])

}

