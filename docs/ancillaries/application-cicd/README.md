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
| <a name="module_global_vars"></a> [global\_vars](#module\_global\_vars) | ../../tf-global | n/a |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | ../../modules/s3 | n/a |
| <a name="module_s3_policy"></a> [s3\_policy](#module\_s3\_policy) | ../../modules/s3-bucket-policy | n/a |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | ../../modules/mgmt-security-group | n/a |
| <a name="module_vpc_fl"></a> [vpc\_fl](#module\_vpc\_fl) | ../../modules/vpc-flow-logs | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_vpc_attachment.tgw_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_route_table.private_subnet_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.tgwa_subnet_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.tgwa_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.cicd_spv_01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.cicd_tgwa_01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_dhcp_options.dhcp_option](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options) | resource |
| [aws_vpc_dhcp_options_association.vpc_dhcp_assoc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.allow_access_from_another_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [terraform_remote_state.central_vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.managed_ad](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.transit_gateway](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | The AWS Account ID number of the account that owns or contains the calling entity. |
| <a name="output_cicd_app_route_table"></a> [cicd\_app\_route\_table](#output\_cicd\_app\_route\_table) | n/a |
| <a name="output_cicd_app_vpc_tgw_att"></a> [cicd\_app\_vpc\_tgw\_att](#output\_cicd\_app\_vpc\_tgw\_att) | # CICD VPC outputs |
| <a name="output_cicd_app_vpc_tgw_subnets"></a> [cicd\_app\_vpc\_tgw\_subnets](#output\_cicd\_app\_vpc\_tgw\_subnets) | n/a |
| <a name="output_cicd_mgmt_sec_group"></a> [cicd\_mgmt\_sec\_group](#output\_cicd\_mgmt\_sec\_group) | n/a |
| <a name="output_cicd_vpc"></a> [cicd\_vpc](#output\_cicd\_vpc) | n/a |
| <a name="output_cicd_vpc_subnet_ids"></a> [cicd\_vpc\_subnet\_ids](#output\_cicd\_vpc\_subnet\_ids) | n/a |
