## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_authorizer.authorizer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_authorizer) | resource |
| [aws_api_gateway_deployment.deployment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_integration.cors_options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration.lambda_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration_response.cors_options_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration_response) | resource |
| [aws_api_gateway_method.auth_post_method](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method.cors_options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method_response.cors_options_response](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_response) | resource |
| [aws_api_gateway_resource.auth_resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_rest_api.saas_api_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_appstream_fleet.fleet_desktop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appstream_fleet) | resource |
| [aws_appstream_fleet_stack_association.fleet_stack](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appstream_fleet_stack_association) | resource |
| [aws_appstream_stack.stack](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appstream_stack) | resource |
| [aws_cloudfront_distribution.website_cdn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_identity.oai](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |
| [aws_cognito_user_pool.cognito_user_pool_saas_portal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_cognito_user_pool_client.cognito_user_pool_saas_portal_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
| [aws_iam_policy.lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.appstream_full_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.appstream_service_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_saas_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_api_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket.appstream_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_website_configuration.website_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [archive_file.lambda_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_subnet_ids_array"></a> [app\_subnet\_ids\_array](#input\_app\_subnet\_ids\_array) | n/a | `any` | n/a | yes |
| <a name="input_appstream_security_group"></a> [appstream\_security\_group](#input\_appstream\_security\_group) | Full Security Group for dependency resolution | `any` | n/a | yes |
| <a name="input_appstream_security_group_id"></a> [appstream\_security\_group\_id](#input\_appstream\_security\_group\_id) | AppStream Security Group Id | `string` | n/a | yes |
| <a name="input_client_env"></a> [client\_env](#input\_client\_env) | The environment specific to the client (e.g., 0000p, 0000t, etc...). | `string` | n/a | yes |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | The ID for the client. | `string` | n/a | yes |
| <a name="input_common"></a> [common](#input\_common) | Common prefix | `string` | n/a | yes |
| <a name="input_env_domain"></a> [env\_domain](#input\_env\_domain) | The domain of this environment | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment specific configurations. | <pre>object({<br>    region                = string<br>    install_egress_access = bool<br>    vpc = object({<br>      cidr           = string<br>      enabled_azs    = list(string)<br>      public_subnets = list(string)<br>      intra_subnets  = list(string)<br>    })<br>    app_vpc = object({<br>      cidr                             = string<br>      enabled_azs                      = list(string)<br>      private_subnets_for_applications = list(string)<br>      private_subnets_for_dbs          = list(string)<br>      intra_subnets                    = list(string)<br>    })<br>    network_account_cidr = string<br>    nginx_config = object({<br>      instance_type = map(string)<br>      ami           = map(string)<br>    })<br>    halo_config = object({<br>      instance_type = map(string)<br>      ami           = map(string)<br>    })<br>    aura_config = object({<br>      instance_type = map(string)<br>      ami           = map(string)<br>    })<br>    core_config = object({<br>      number_of_secondary_ips = number<br>      instance_type           = map(string)<br>      ami                     = map(string)<br>    })<br>    mdb_config = object({<br>      number_of_secondary_ips = number<br>      instance_type           = map(string)<br>      ami                     = map(string)<br>    })<br>    rdb_config = object({<br>      number_of_secondary_ips = number<br>      instance_type           = map(string)<br>      ami                     = map(string)<br>    })<br>    workhours         = string<br>    out_of_workhours  = string<br>    delayed_workhours = string<br>  })</pre> | n/a | yes |
| <a name="input_global_vars"></a> [global\_vars](#input\_global\_vars) | Global variables that are common across the infrastructure. | `any` | n/a | yes |
| <a name="input_tier"></a> [tier](#input\_tier) | Type of tier (tier1, tier2, tier3) | `string` | n/a | yes |

## Outputs

No outputs.
