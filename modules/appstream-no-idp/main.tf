# S3 bucket to store website
resource "aws_s3_bucket" "appstream_bucket" {
  bucket        = local.appstream_bucket_name
  force_destroy = true
}
resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.appstream_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.appstream_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "s3:GetObject"
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.appstream_bucket.arn}/*"
        Principal = {
          AWS = [aws_cloudfront_origin_access_identity.oai.iam_arn]
        }
      },
    ]
  })
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "website_cdn" {
  origin {
    domain_name = aws_s3_bucket.appstream_bucket.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.appstream_bucket.id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.appstream_bucket.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for AppStream Website"
}

# Cognito
resource "aws_cognito_user_pool" "cognito_user_pool_saas_portal" {
  #name = "examplecorp_saas"
  name = local.saas_portal_name

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  # Add additional configuration options as needed
  email_configuration {
    email_sending_account  = local.email_sending_account_type
    #from_email_address should be noreply@lendscape.com or similar
    from_email_address = "marcos@cloud-bridge.co.uk"
    reply_to_email_address = "marcos@cloud-bridge.co.uk"
    #reply_to_email_address = "noreply@lendscape.com" # Still to be confirmed
    # Source ARN should be the SES identity used for noreply@lendscape.com or whatever email used for this,
    # it must be injected dynamically if there are different emails per client (shouldn't be the case)
    source_arn = "arn:aws:ses:eu-west-1:967702029755:identity/marcos@cloud-bridge.co.uk"
  }

  auto_verified_attributes = ["email"]
}
resource "aws_cognito_user_pool_client" "cognito_user_pool_saas_portal_app" {
  name            = "saas_app"
  user_pool_id    = aws_cognito_user_pool.cognito_user_pool_saas_portal.id
  generate_secret = false # Client secrets are not supported for browser-based apps
}
resource "aws_iam_policy" "lambda_policy" {
  name        = "LambdaPolicy"
  description = "A policy for Lambda and AppStream"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["appstream:CreateStreamingURL"]
        Resource = [
          aws_appstream_fleet.fleet_desktop.arn,
          aws_appstream_stack.stack.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = ["*"]
      }
    ]
  })
}

# AppStream 2.0
# This role is required if the account has never created a new stack/fleet/image builder before
resource "aws_iam_role" "appstream_service_role" {
  name = "AppStreamServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "appstream.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}
resource "aws_iam_policy_attachment" "appstream_full_access" {
  name       = "AppStreamFullAccess"
  roles      = [aws_iam_role.appstream_service_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonAppStreamFullAccess"
}
# Fleet
resource "aws_appstream_fleet" "fleet_desktop" {
  # This depends on is required in order to wait for this resource to be fully created
  depends_on = [var.appstream_security_group, var.appstream_security_group_id]
  name = local.fleet_name

  compute_capacity {
    desired_instances = 1
  }

  description                        = "POC Testing Fleet"
  idle_disconnect_timeout_in_seconds = 600
  display_name                       = "poc"
  enable_default_internet_access     = false
  fleet_type                         = "ON_DEMAND"
  image_name                         = "AQ-Client-Image-Builder-TEST-v2"
  instance_type                      = "stream.standard.medium"
  max_user_duration_in_seconds       = 3600
  stream_view                        = "APP"

  vpc_config {
    subnet_ids         = var.app_subnet_ids_array
    security_group_ids = [var.appstream_security_group_id]
  }
}
# Stack
resource "aws_appstream_stack" "stack" {
  name         = local.stack_name
  description  = "Stack for Customer"
  display_name = "Stack for Customer"

  user_settings {
    action     = "DOMAIN_PASSWORD_SIGNIN"
    permission = "ENABLED"
  }

  user_settings {
    action     = "DOMAIN_SMART_CARD_SIGNIN"
    permission = "DISABLED"
  }
  user_settings {
    action     = "FILE_DOWNLOAD"
    permission = "ENABLED"
  }
  user_settings {
    action     = "FILE_UPLOAD"
    permission = "ENABLED"
  }
  user_settings {
    action     = "PRINTING_TO_LOCAL_DEVICE"
    permission = "ENABLED"
  }

  user_settings {
    action     = "CLIPBOARD_COPY_FROM_LOCAL_DEVICE"
    permission = "ENABLED"
  }

  user_settings {
    action     = "CLIPBOARD_COPY_TO_LOCAL_DEVICE"
    permission = "ENABLED"
  }
  application_settings {
    enabled        = true
    settings_group = "SettingsGroup"
  }

}
# Fleet - Stack association
resource "aws_appstream_fleet_stack_association" "fleet_stack" {
  fleet_name = aws_appstream_fleet.fleet_desktop.name
  stack_name = aws_appstream_stack.stack.name
}

# Lambda
resource "aws_iam_role" "lambda_saas_role" {
  name = "lambda_saas_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "policy_attach" {
  role       = aws_iam_role.lambda_saas_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
data "archive_file" "lambda_zip" {
  type = "zip"
  source_content = templatefile("${path.module}/lambda/index.js.tpl", {
    cdn_domain = aws_cloudfront_distribution.website_cdn.domain_name
    fleet_name = aws_appstream_fleet.fleet_desktop.name
    stack_name = aws_appstream_stack.stack.name
  })
  source_content_filename = "index.js"
  output_path             = "${path.module}/lambda/lambda_function.zip"
}
resource "aws_lambda_function" "lambda_function" {
  depends_on = [
    aws_iam_role.lambda_saas_role,
    aws_cloudfront_distribution.website_cdn,
    aws_appstream_fleet.fleet_desktop,
    aws_appstream_stack.stack
  ]

  function_name = local.lambda_saas_function_name
  handler       = "index.handler"                   # Assuming handler function is named 'handler' in 'index.js.tpl'
  role          = aws_iam_role.lambda_saas_role.arn # Reference to Lambda execution role
  runtime       = "nodejs16.x"
  filename      = data.archive_file.lambda_zip.output_path
}

#Api Gateway
resource "aws_api_gateway_rest_api" "saas_api_gateway" {
  name        = local.saas_api_gateway_name
  description = local.saas_api_gateway_description

  endpoint_configuration {
    types = ["EDGE"]
  }
}
resource "aws_api_gateway_authorizer" "authorizer" {
  name            = local.authorizer_name
  type            = "COGNITO_USER_POOLS"
  rest_api_id     = aws_api_gateway_rest_api.saas_api_gateway.id
  identity_source = "method.request.header.Authorization"
  provider_arns   = [aws_cognito_user_pool.cognito_user_pool_saas_portal.arn]
}
resource "aws_api_gateway_resource" "auth_resource" {
  rest_api_id = aws_api_gateway_rest_api.saas_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.saas_api_gateway.root_resource_id
  path_part   = "auth"
}
resource "aws_api_gateway_method" "auth_post_method" {
  rest_api_id   = aws_api_gateway_rest_api.saas_api_gateway.id
  resource_id   = aws_api_gateway_resource.auth_resource.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.authorizer.id
}
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.saas_api_gateway.id
  resource_id             = aws_api_gateway_resource.auth_resource.id
  http_method             = aws_api_gateway_method.auth_post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}
resource "aws_api_gateway_method" "cors_options" {
  rest_api_id   = aws_api_gateway_rest_api.saas_api_gateway.id
  resource_id   = aws_api_gateway_resource.auth_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}
resource "aws_api_gateway_method_response" "cors_options_response" {
  rest_api_id = aws_api_gateway_rest_api.saas_api_gateway.id
  resource_id = aws_api_gateway_resource.auth_resource.id
  http_method = aws_api_gateway_method.cors_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Credentials" = false
    "method.response.header.Access-Control-Allow-Headers"     = false
    "method.response.header.Access-Control-Allow-Methods"     = false
    "method.response.header.Access-Control-Allow-Origin"      = false
  }
}
resource "aws_api_gateway_integration_response" "cors_options_integration" {
  depends_on  = [aws_api_gateway_integration.cors_options]
  rest_api_id = aws_api_gateway_rest_api.saas_api_gateway.id
  resource_id = aws_api_gateway_resource.auth_resource.id
  http_method = aws_api_gateway_method.cors_options.http_method
  status_code = aws_api_gateway_method_response.cors_options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }
}
resource "aws_api_gateway_integration" "cors_options" {
  rest_api_id = aws_api_gateway_rest_api.saas_api_gateway.id
  resource_id = aws_api_gateway_resource.auth_resource.id
  http_method = aws_api_gateway_method.cors_options.http_method
  type        = "MOCK"
  #  integration_http_method = "OPTIONS"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}
resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.saas_api_gateway.execution_arn}/*/*"
}
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [aws_api_gateway_integration.lambda_integration]

  rest_api_id = aws_api_gateway_rest_api.saas_api_gateway.id
  stage_name  = "auth"
}