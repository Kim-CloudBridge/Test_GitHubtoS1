## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gateway_vpc_fl"></a> [gateway\_vpc\_fl](#module\_gateway\_vpc\_fl) | ../../../modules/vpc-flow-logs | n/a |
| <a name="module_globalvars"></a> [globalvars](#module\_globalvars) | ../../../tf-global | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_vpc_attachment.tgw-att-mgmt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_eip.eip-mgmt1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip.eip-mgmt2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip.eip-shared](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.APICall_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.APICallpolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.APICall-attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.APICallrole](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_instance.fgt1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.fgt2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.firewall_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_key_pair.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_network_acl.fw_spb_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.fw_spv_01_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.fw_spv_02_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_interface.eni-fgt1-data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_network_interface.eni-fgt1-hb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_network_interface.eni-fgt1-mgmt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_network_interface.eni-fgt2-data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_network_interface.eni-fgt2-hb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_network_interface.eni-fgt2-mgmt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_route.rly_01_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.rly_02_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.spb_rtb_igw_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.spb_rtb_op_cidr_tgw_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.spb_rtb_tgw_dmz_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.spb_rtb_tgw_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.fw_spb_rtb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.fw_spv_01_rtb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.fw_spv_02_rtb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.fw_spb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.fw_spv_01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.fw_spv_02](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_secretsmanager_secret.keypair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.keypair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.fg2-data-sgp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.fg2-hasync-sgp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.fg2-mgmt-sgp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.hasync-self-in](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.hasync-self-out](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_subnet.fw_spb_01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.fw_spb_02](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.fw_spv_01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.fw_spv_02](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.firewall_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [tls_private_key.key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_ssm_parameter.fortigate_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [terraform_remote_state.central_vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.transit_gateway](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_arch"></a> [arch](#input\_arch) | instance architect | `string` | `"x86"` | no |
| <a name="input_env_domain"></a> [env\_domain](#input\_env\_domain) | The domain of this environment | `string` | `"MGMT"` | no |
| <a name="input_firewall_cidr_block"></a> [firewall\_cidr\_block](#input\_firewall\_cidr\_block) | n/a | `string` | `"10.210.122.0/24"` | no |
| <a name="input_firewall_private_subnets"></a> [firewall\_private\_subnets](#input\_firewall\_private\_subnets) | n/a | `list(any)` | <pre>[<br>  "10.210.122.0/28",<br>  "10.210.122.16/28",<br>  "10.210.122.32/28",<br>  "10.210.122.48/28"<br>]</pre> | no |
| <a name="input_firewall_public_subnets"></a> [firewall\_public\_subnets](#input\_firewall\_public\_subnets) | n/a | `list(any)` | <pre>[<br>  "10.210.122.64/28",<br>  "10.210.122.80/28",<br>  "10.210.122.128/26",<br>  "10.210.122.192/26"<br>]</pre> | no |
| <a name="input_hms_client_id"></a> [hms\_client\_id](#input\_hms\_client\_id) | n/a | `string` | `"0000"` | no |
| <a name="input_hms_deployment"></a> [hms\_deployment](#input\_hms\_deployment) | n/a | `string` | `"fg2"` | no |
| <a name="input_hms_environment_id"></a> [hms\_environment\_id](#input\_hms\_environment\_id) | n/a | `string` | `"n"` | no |
| <a name="input_hms_product_id"></a> [hms\_product\_id](#input\_hms\_product\_id) | UpdateMe | `string` | `"hms"` | no |
| <a name="input_hms_region_id"></a> [hms\_region\_id](#input\_hms\_region\_id) | n/a | `string` | `"01"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Provide the instance type for the FortiGate instances | `string` | `"t3.small"` | no |
| <a name="input_license"></a> [license](#input\_license) | license file for the active fgt | `string` | `"license.txt"` | no |
| <a name="input_license2"></a> [license2](#input\_license2) | license file for the passive fgt | `string` | `"license2.txt"` | no |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | License Type to create FortiGate-VM | `string` | `"byol"` | no |
| <a name="input_log_format"></a> [log\_format](#input\_log\_format) | The fields to include in the flow log record, in the order in which they should appear. | `string` | `null` | no |
| <a name="input_password"></a> [password](#input\_password) | n/a | `string` | `"fortinet"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"eu-west-2"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | `{}` | no |
| <a name="input_traffic_type"></a> [traffic\_type](#input\_traffic\_type) | The type of traffic to capture. Valid values: `ACCEPT`, `REJECT`, `ALL` | `string` | `"ALL"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_FGT_Active_MGMT_Public_IP"></a> [FGT\_Active\_MGMT\_Public\_IP](#output\_FGT\_Active\_MGMT\_Public\_IP) | Public IP address for the Active FortiGate's MGMT interface |
| <a name="output_FGT_Cluster_Public_IP"></a> [FGT\_Cluster\_Public\_IP](#output\_FGT\_Cluster\_Public\_IP) | Public IP address for the Cluster |
| <a name="output_FGT_Passive_MGMT_Public_IP"></a> [FGT\_Passive\_MGMT\_Public\_IP](#output\_FGT\_Passive\_MGMT\_Public\_IP) | Public IP address for the Passive FortiGate's MGMT interface |
| <a name="output_FGT_Password"></a> [FGT\_Password](#output\_FGT\_Password) | Default Password for FortiGate Cluster |
| <a name="output_FGT_Username"></a> [FGT\_Username](#output\_FGT\_Username) | Default Username for FortiGate Cluster |
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | The AWS Account ID number of the account that owns or contains the calling entity. |
| <a name="output_firewall_data_public_subnets"></a> [firewall\_data\_public\_subnets](#output\_firewall\_data\_public\_subnets) | n/a |
| <a name="output_firewall_hasync_private_subnets"></a> [firewall\_hasync\_private\_subnets](#output\_firewall\_hasync\_private\_subnets) | n/a |
| <a name="output_firewall_mgmt_public_subnets"></a> [firewall\_mgmt\_public\_subnets](#output\_firewall\_mgmt\_public\_subnets) | n/a |
| <a name="output_firewall_relay_private_subnets"></a> [firewall\_relay\_private\_subnets](#output\_firewall\_relay\_private\_subnets) | n/a |
| <a name="output_firewall_tgw_route_table"></a> [firewall\_tgw\_route\_table](#output\_firewall\_tgw\_route\_table) | n/a |
| <a name="output_firewall_vpc_cidr"></a> [firewall\_vpc\_cidr](#output\_firewall\_vpc\_cidr) | n/a |
| <a name="output_firewall_vpc_id"></a> [firewall\_vpc\_id](#output\_firewall\_vpc\_id) | n/a |
| <a name="output_firewall_vpc_tgw_subnets"></a> [firewall\_vpc\_tgw\_subnets](#output\_firewall\_vpc\_tgw\_subnets) | n/a |
| <a name="output_tgw_attachment"></a> [tgw\_attachment](#output\_tgw\_attachment) | n/a |
