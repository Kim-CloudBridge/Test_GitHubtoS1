## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.18.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.18.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dmz_alb"></a> [dmz\_alb](#module\_dmz\_alb) | ../../modules/dmz-alb | n/a |
| <a name="module_dmz_security_group"></a> [dmz\_security\_group](#module\_dmz\_security\_group) | ../../modules/dmz-security-groups | n/a |
| <a name="module_dmz_vpc"></a> [dmz\_vpc](#module\_dmz\_vpc) | git@bitbucket.org:hms2cloud/iac.git//modules/dmz-vpc | dmz-vpc-2.0 |
| <a name="module_gateway_vpc_fl"></a> [gateway\_vpc\_fl](#module\_gateway\_vpc\_fl) | ../../modules/vpc-flow-logs | n/a |
| <a name="module_global_vars"></a> [global\_vars](#module\_global\_vars) | ../../tf-global | n/a |
| <a name="module_nginx"></a> [nginx](#module\_nginx) | git@bitbucket.org:hms2cloud/iac.git//modules/nginx | dmz-vpc-2.0 |
| <a name="module_waf"></a> [waf](#module\_waf) | ../../modules/waf | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.ssm_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.secrets_manager_get_secret_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ssm_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cloudwatchagent_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.s3_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.secrets_manager_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_directory_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [terraform_remote_state.central_vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.transit_gateway](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | n/a | `string` | n/a | yes |
| <a name="input_env_domain"></a> [env\_domain](#input\_env\_domain) | n/a | `string` | n/a | yes |
| <a name="input_env_suffix"></a> [env\_suffix](#input\_env\_suffix) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region of Deployment | `string` | n/a | yes |
| <a name="input_tier"></a> [tier](#input\_tier) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | The AWS Account ID number of the account that owns or contains the calling entity. |
| <a name="output_test_dmz_alb_security_group_id"></a> [test\_dmz\_alb\_security\_group\_id](#output\_test\_dmz\_alb\_security\_group\_id) | n/a |
| <a name="output_test_dmz_nginx_security_group_id"></a> [test\_dmz\_nginx\_security\_group\_id](#output\_test\_dmz\_nginx\_security\_group\_id) | n/a |
| <a name="output_test_dmz_route_table"></a> [test\_dmz\_route\_table](#output\_test\_dmz\_route\_table) | n/a |
| <a name="output_test_dmz_vpc_tgw_att"></a> [test\_dmz\_vpc\_tgw\_att](#output\_test\_dmz\_vpc\_tgw\_att) | # DMZ VPC outputs |
| <a name="output_test_dmz_vpc_tgw_subnets"></a> [test\_dmz\_vpc\_tgw\_subnets](#output\_test\_dmz\_vpc\_tgw\_subnets) | n/a |
