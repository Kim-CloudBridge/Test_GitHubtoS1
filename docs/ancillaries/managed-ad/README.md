## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_global_vars"></a> [global\_vars](#module\_global\_vars) | ../../tf-global | n/a |
| <a name="module_globalvars"></a> [globalvars](#module\_globalvars) | ../../tf-global | n/a |
| <a name="module_vpc_fl"></a> [vpc\_fl](#module\_vpc\_fl) | ../../modules/vpc-flow-logs | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.managed_ad_cwlogs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_resource_policy.ad_log_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy) | resource |
| [aws_directory_service_directory.microsoft_ad](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_directory) | resource |
| [aws_directory_service_log_subscription.cloudwatch_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_log_subscription) | resource |
| [aws_directory_service_shared_directory.ad_sharing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_shared_directory) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.tgw_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_route_table.private_subnet_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public_subnet_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_secretsmanager_secret.managed_ad_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.managed_ad_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group_rule.onpremise_dns_host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_subnet.shared_spb_01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.shared_spv_01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_iam_policy_document.ad_log_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_secretsmanager_secret_version.creds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [terraform_remote_state.central_vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.transit_gateway](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_ids"></a> [account\_ids](#input\_account\_ids) | n/a | `list(any)` | n/a | yes |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | n/a | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | n/a | `map(any)` | `{}` | no |
| <a name="input_directory_name"></a> [directory\_name](#input\_directory\_name) | n/a | `string` | n/a | yes |
| <a name="input_env_domain"></a> [env\_domain](#input\_env\_domain) | The domain of this environment | `string` | `"MGMT"` | no |
| <a name="input_environment_id"></a> [environment\_id](#input\_environment\_id) | n/a | `string` | `"n"` | no |
| <a name="input_managed_ad_password"></a> [managed\_ad\_password](#input\_managed\_ad\_password) | n/a | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_region_alias"></a> [region\_alias](#input\_region\_alias) | n/a | `string` | n/a | yes |
| <a name="input_shared_private_subnets"></a> [shared\_private\_subnets](#input\_shared\_private\_subnets) | n/a | `list(any)` | <pre>[<br>  "10.210.124.128/26",<br>  "10.210.124.192/26"<br>]</pre> | no |
| <a name="input_shared_public_subnets"></a> [shared\_public\_subnets](#input\_shared\_public\_subnets) | n/a | `list(any)` | <pre>[<br>  "10.210.124.0/26",<br>  "10.210.124.64/26"<br>]</pre> | no |
| <a name="input_shared_svcs_vpc_cidr"></a> [shared\_svcs\_vpc\_cidr](#input\_shared\_svcs\_vpc\_cidr) | Use /22 (1022 hosts) CIDR for VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_managed_ad_dns_name"></a> [managed\_ad\_dns\_name](#output\_managed\_ad\_dns\_name) | n/a |
| <a name="output_managed_ad_id"></a> [managed\_ad\_id](#output\_managed\_ad\_id) | n/a |
| <a name="output_managed_ad_ips"></a> [managed\_ad\_ips](#output\_managed\_ad\_ips) | n/a |
| <a name="output_private_rtb"></a> [private\_rtb](#output\_private\_rtb) | n/a |
| <a name="output_private_subnets_cidr"></a> [private\_subnets\_cidr](#output\_private\_subnets\_cidr) | n/a |
| <a name="output_public_rtb"></a> [public\_rtb](#output\_public\_rtb) | n/a |
| <a name="output_shared_directory_ids"></a> [shared\_directory\_ids](#output\_shared\_directory\_ids) | n/a |
| <a name="output_shared_svcs_vpc_cidr"></a> [shared\_svcs\_vpc\_cidr](#output\_shared\_svcs\_vpc\_cidr) | n/a |
| <a name="output_shared_vpc_tgw_subnets"></a> [shared\_vpc\_tgw\_subnets](#output\_shared\_vpc\_tgw\_subnets) | n/a |
| <a name="output_tgw_attachment_id"></a> [tgw\_attachment\_id](#output\_tgw\_attachment\_id) | n/a |
