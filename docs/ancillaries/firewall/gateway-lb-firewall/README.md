## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.5.1 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_firewall_vpc_fl"></a> [firewall\_vpc\_fl](#module\_firewall\_vpc\_fl) | ../../../modules/vpc-flow-logs | n/a |
| <a name="module_gateway_vpc_fl"></a> [gateway\_vpc\_fl](#module\_gateway\_vpc\_fl) | ../../../modules/vpc-flow-logs | n/a |
| <a name="module_globalvars"></a> [globalvars](#module\_globalvars) | ../../../tf-global | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_vpc_attachment.firewall_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.gateway_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_eip.eth0_port1_aza](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip.eth0_port1_azb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip_association.eip_assoc_aza](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association) | resource |
| [aws_eip_association.eip_assoc_azb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association) | resource |
| [aws_instance.fgtvm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.fgtvm_azb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.firewall_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_key_pair.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_lb.gateway_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.fg1_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.fg1_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.fgt1Aattach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.fgt1Battach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_network_acl.fw_spb_01_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.fw_spv_01_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.fw_spv_02_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.spv_01_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.spv_02_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_interface.eth0](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_network_interface.eth0_azb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_network_interface.eth1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_network_interface.eth1_azb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_route.spb_01_rtb_igw_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.spb_01_rtb_tgw_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.spv_01_rtb_gwlbe_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.spv_02_rtb_dmz_tgw_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.spv_02_rtb_tgw_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.fw_spb_01_rtb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.fw_spv_01_rtb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.fw_spv_02_rtb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.spv_01_rtb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.spv_02_rtb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.fw_spb_01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.fw_spv_01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.fw_spv_02](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.spv_01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.spv_02](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_secretsmanager_secret.keypair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.keypair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.allow_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.management_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.public_allow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.fw_spb_01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.fw_spv_01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.fw_spv_02](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.spv_01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.spv_02](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.firewall_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc.gateway_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_endpoint.gwlb_endpoint_fg1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_service.fg1_gwlb_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_service) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [tls_private_key.key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_network_interface.eth1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/network_interface) | data source |
| [aws_network_interface.eth1_azb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/network_interface) | data source |
| [aws_network_interface.vpcendpointip_aza](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/network_interface) | data source |
| [aws_network_interface.vpcendpointip_azb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/network_interface) | data source |
| [aws_secretsmanager_secret.lic_token_01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret.lic_token_02](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.lic_token_01_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_secretsmanager_secret_version.lic_token_02_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_ssm_parameter.fortigate_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_vpc_endpoint.gwlbe](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint) | data source |
| [aws_vpc_endpoint.gwlbe_azb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint) | data source |
| [terraform_remote_state.central_vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.transit_gateway](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_adminsport"></a> [adminsport](#input\_adminsport) | Admin HTTPS access port | `string` | `"443"` | no |
| <a name="input_arch"></a> [arch](#input\_arch) | FortiGate instance architect Either arm or x86 | `string` | `"arm"` | no |
| <a name="input_bootstrap-fgtvm"></a> [bootstrap-fgtvm](#input\_bootstrap-fgtvm) | n/a | `string` | `"fgtvm.conf"` | no |
| <a name="input_bootstrap-fgtvm2"></a> [bootstrap-fgtvm2](#input\_bootstrap-fgtvm2) | n/a | `string` | `"fgtvm2.conf"` | no |
| <a name="input_default_network_acl_egress"></a> [default\_network\_acl\_egress](#input\_default\_network\_acl\_egress) | n/a | `list(map(string))` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  },<br>  {<br>    "action": "allow",<br>    "from_port": 0,<br>    "ipv6_cidr_block": "::/0",<br>    "protocol": "-1",<br>    "rule_no": 101,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_default_network_acl_ingress"></a> [default\_network\_acl\_ingress](#input\_default\_network\_acl\_ingress) | n/a | `list(map(string))` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  },<br>  {<br>    "action": "allow",<br>    "from_port": 0,<br>    "ipv6_cidr_block": "::/0",<br>    "protocol": "-1",<br>    "rule_no": 101,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_env_domain"></a> [env\_domain](#input\_env\_domain) | The domain of this environment | `string` | `"MGMT"` | no |
| <a name="input_fgtami"></a> [fgtami](#input\_fgtami) | AMIs for FGTVM-7.4.1 | `string` | `"ami-id"` | no |
| <a name="input_firewall_cidr_block"></a> [firewall\_cidr\_block](#input\_firewall\_cidr\_block) | n/a | `string` | `"10.210.120.0/24"` | no |
| <a name="input_firewall_private_subnets"></a> [firewall\_private\_subnets](#input\_firewall\_private\_subnets) | n/a | `list(any)` | <pre>[<br>  "10.210.120.0/27",<br>  "10.210.120.32/27",<br>  "10.210.120.64/26",<br>  "10.210.120.128/26"<br>]</pre> | no |
| <a name="input_firewall_public_subnets"></a> [firewall\_public\_subnets](#input\_firewall\_public\_subnets) | n/a | `list(any)` | <pre>[<br>  "10.210.120.192/27",<br>  "10.210.120.224/27"<br>]</pre> | no |
| <a name="input_gateway_cidr_block"></a> [gateway\_cidr\_block](#input\_gateway\_cidr\_block) | n/a | `string` | `"10.210.121.0/24"` | no |
| <a name="input_gateway_private_subnets"></a> [gateway\_private\_subnets](#input\_gateway\_private\_subnets) | n/a | `list(any)` | <pre>[<br>  "10.210.121.0/27",<br>  "10.210.121.32/27",<br>  "10.210.121.64/27",<br>  "10.210.121.96/27"<br>]</pre> | no |
| <a name="input_hms_client_id"></a> [hms\_client\_id](#input\_hms\_client\_id) | n/a | `string` | `"0000"` | no |
| <a name="input_hms_deployment"></a> [hms\_deployment](#input\_hms\_deployment) | n/a | `string` | `"fg1"` | no |
| <a name="input_hms_environment_id"></a> [hms\_environment\_id](#input\_hms\_environment\_id) | n/a | `string` | `"n"` | no |
| <a name="input_hms_product_id"></a> [hms\_product\_id](#input\_hms\_product\_id) | n/a | `string` | `"hms"` | no |
| <a name="input_hms_region_id"></a> [hms\_region\_id](#input\_hms\_region\_id) | n/a | `string` | `"01"` | no |
| <a name="input_keyname"></a> [keyname](#input\_keyname) | Existing SSH Key on the AWS | `string` | `"<AWS SSH KEY>"` | no |
| <a name="input_licence"></a> [licence](#input\_licence) | licence file for the fgt | `string` | `"licence.lic"` | no |
| <a name="input_licence2"></a> [licence2](#input\_licence2) | licence file for the fgt 2 | `string` | `"licence2.lic"` | no |
| <a name="input_licence_type"></a> [licence\_type](#input\_licence\_type) | licence Type to create FortiGate-VM Provide the licence type for FortiGate-VM Instances, either byol or payg. | `string` | `"payg"` | no |
| <a name="input_log_format"></a> [log\_format](#input\_log\_format) | The fields to include in the flow log record, in the order in which they should appear. | `string` | `null` | no |
| <a name="input_management_ports"></a> [management\_ports](#input\_management\_ports) | instance type needs to match the architect c5.xlarge is x86\_64 c6g.xlarge is arm For detail, refer to https://aws.amazon.com/ec2/instance-types/ | `list(any)` | <pre>[<br>  22,<br>  443,<br>  8443<br>]</pre> | no |
| <a name="input_private_inbound_acl_rules"></a> [private\_inbound\_acl\_rules](#input\_private\_inbound\_acl\_rules) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_private_outbound_acl_rules"></a> [private\_outbound\_acl\_rules](#input\_private\_outbound\_acl\_rules) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_public_inbound_acl_rules"></a> [public\_inbound\_acl\_rules](#input\_public\_inbound\_acl\_rules) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_public_outbound_acl_rules"></a> [public\_outbound\_acl\_rules](#input\_public\_outbound\_acl\_rules) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"eu-west-2"` | no |
| <a name="input_size"></a> [size](#input\_size) | n/a | `string` | `"t2.micro"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | `{}` | no |
| <a name="input_traffic_type"></a> [traffic\_type](#input\_traffic\_type) | The type of traffic to capture. Valid values: `ACCEPT`, `REJECT`, `ALL` | `string` | `"ALL"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ami"></a> [ami](#output\_ami) | n/a |
| <a name="output_fg1_gwlb_service"></a> [fg1\_gwlb\_service](#output\_fg1\_gwlb\_service) | n/a |
| <a name="output_firewall_gateway_lb"></a> [firewall\_gateway\_lb](#output\_firewall\_gateway\_lb) | n/a |
| <a name="output_firewall_private_subnets"></a> [firewall\_private\_subnets](#output\_firewall\_private\_subnets) | n/a |
| <a name="output_firewall_spv_01_route_table_ids"></a> [firewall\_spv\_01\_route\_table\_ids](#output\_firewall\_spv\_01\_route\_table\_ids) | n/a |
| <a name="output_firewall_spv_02_route_table_ids"></a> [firewall\_spv\_02\_route\_table\_ids](#output\_firewall\_spv\_02\_route\_table\_ids) | n/a |
| <a name="output_firewall_vpc_cidr"></a> [firewall\_vpc\_cidr](#output\_firewall\_vpc\_cidr) | n/a |
| <a name="output_firewall_vpc_id"></a> [firewall\_vpc\_id](#output\_firewall\_vpc\_id) | n/a |
| <a name="output_firewall_vpc_tgw_subnets"></a> [firewall\_vpc\_tgw\_subnets](#output\_firewall\_vpc\_tgw\_subnets) | n/a |
| <a name="output_firewall_vpc_tgw_subnets_route_table_ids"></a> [firewall\_vpc\_tgw\_subnets\_route\_table\_ids](#output\_firewall\_vpc\_tgw\_subnets\_route\_table\_ids) | n/a |
| <a name="output_firewall_vpc_transit_gateway_vpc_attachment"></a> [firewall\_vpc\_transit\_gateway\_vpc\_attachment](#output\_firewall\_vpc\_transit\_gateway\_vpc\_attachment) | TGW |
| <a name="output_gateway_load_balancer_endpoints"></a> [gateway\_load\_balancer\_endpoints](#output\_gateway\_load\_balancer\_endpoints) | n/a |
| <a name="output_gateway_private_subnets"></a> [gateway\_private\_subnets](#output\_gateway\_private\_subnets) | n/a |
| <a name="output_gateway_spv_01_route_table_ids"></a> [gateway\_spv\_01\_route\_table\_ids](#output\_gateway\_spv\_01\_route\_table\_ids) | n/a |
| <a name="output_gateway_spv_02_route_table_ids"></a> [gateway\_spv\_02\_route\_table\_ids](#output\_gateway\_spv\_02\_route\_table\_ids) | n/a |
| <a name="output_gateway_vpc_id"></a> [gateway\_vpc\_id](#output\_gateway\_vpc\_id) | n/a |
| <a name="output_gateway_vpc_tgw_subnets"></a> [gateway\_vpc\_tgw\_subnets](#output\_gateway\_vpc\_tgw\_subnets) | n/a |
| <a name="output_gateway_vpc_tgw_subnets_route_table_ids"></a> [gateway\_vpc\_tgw\_subnets\_route\_table\_ids](#output\_gateway\_vpc\_tgw\_subnets\_route\_table\_ids) | n/a |
| <a name="output_gateway_vpc_transit_gateway_vpc_attachment"></a> [gateway\_vpc\_transit\_gateway\_vpc\_attachment](#output\_gateway\_vpc\_transit\_gateway\_vpc\_attachment) | n/a |
