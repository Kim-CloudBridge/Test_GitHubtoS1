## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.18.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.18.1 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app_vpc"></a> [app\_vpc](#module\_app\_vpc) | ../../modules/app-vpc | n/a |
| <a name="module_appstream_no_idp"></a> [appstream\_no\_idp](#module\_appstream\_no\_idp) | ../../modules/appstream-no-idp | n/a |
| <a name="module_aura"></a> [aura](#module\_aura) | ../../modules/aura | n/a |
| <a name="module_auto_managed_instances"></a> [auto\_managed\_instances](#module\_auto\_managed\_instances) | ../../modules/auto-managed-instances | n/a |
| <a name="module_core"></a> [core](#module\_core) | ../../modules/core | n/a |
| <a name="module_core_fsxn"></a> [core\_fsxn](#module\_core\_fsxn) | ../../modules/core | n/a |
| <a name="module_dmz_vpc"></a> [dmz\_vpc](#module\_dmz\_vpc) | ../../modules/dmz-vpc | n/a |
| <a name="module_fsxn_multiaz"></a> [fsxn\_multiaz](#module\_fsxn\_multiaz) | ../../modules/fsxn | n/a |
| <a name="module_gateway_vpc_fl"></a> [gateway\_vpc\_fl](#module\_gateway\_vpc\_fl) | ../../modules/vpc-flow-logs | n/a |
| <a name="module_global_vars"></a> [global\_vars](#module\_global\_vars) | ../../tf-global | n/a |
| <a name="module_halo"></a> [halo](#module\_halo) | ../../modules/halo | n/a |
| <a name="module_iam"></a> [iam](#module\_iam) | ../../modules/iam | n/a |
| <a name="module_lb"></a> [lb](#module\_lb) | ../../modules/lb | n/a |
| <a name="module_mdb"></a> [mdb](#module\_mdb) | ../../modules/mdb | n/a |
| <a name="module_mdb_fsxn"></a> [mdb\_fsxn](#module\_mdb\_fsxn) | ../../modules/mdb | n/a |
| <a name="module_nginx"></a> [nginx](#module\_nginx) | ../../modules/nginx | n/a |
| <a name="module_rdb"></a> [rdb](#module\_rdb) | ../../modules/rdb | n/a |
| <a name="module_rdb_fsxn"></a> [rdb\_fsxn](#module\_rdb\_fsxn) | ../../modules/rdb | n/a |
| <a name="module_security_groups"></a> [security\_groups](#module\_security\_groups) | ../../modules/security-groups | n/a |
| <a name="module_ssm_domain_join"></a> [ssm\_domain\_join](#module\_ssm\_domain\_join) | ../../modules/ssm-domain-join | n/a |
| <a name="module_target_groups"></a> [target\_groups](#module\_target\_groups) | ../../modules/target-groups | n/a |
| <a name="module_vpc_peering"></a> [vpc\_peering](#module\_vpc\_peering) | ../../modules/vpc-peering | n/a |
| <a name="module_waf"></a> [waf](#module\_waf) | ../../modules/waf | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ssm_association.ssm_domain_join](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_association) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_secretsmanager_secret.ad_admin_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.ad_admin_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [terraform_remote_state.central_vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.ew_firewall](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.managed_ad](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.transit_gateway](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | The AWS Account ID number of the account that owns or contains the calling entity. |
| <a name="output_client-0000_app_route_table"></a> [client-0000\_app\_route\_table](#output\_client-0000\_app\_route\_table) | n/a |
| <a name="output_client-0000_app_vpc_tgw_att"></a> [client-0000\_app\_vpc\_tgw\_att](#output\_client-0000\_app\_vpc\_tgw\_att) | # APP VPC outputs |
| <a name="output_client-0000_app_vpc_tgw_subnets"></a> [client-0000\_app\_vpc\_tgw\_subnets](#output\_client-0000\_app\_vpc\_tgw\_subnets) | n/a |
| <a name="output_client-0000_dmz_route_table"></a> [client-0000\_dmz\_route\_table](#output\_client-0000\_dmz\_route\_table) | n/a |
| <a name="output_client-0000_dmz_vpc_tgw_att"></a> [client-0000\_dmz\_vpc\_tgw\_att](#output\_client-0000\_dmz\_vpc\_tgw\_att) | # DMZ VPC outputs |
| <a name="output_client-0000_dmz_vpc_tgw_subnets"></a> [client-0000\_dmz\_vpc\_tgw\_subnets](#output\_client-0000\_dmz\_vpc\_tgw\_subnets) | n/a |
