## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app_vpc"></a> [app\_vpc](#module\_app\_vpc) | terraform-aws-modules/vpc/aws | 5.1.2 |
| <a name="module_vpc_endpoint"></a> [vpc\_endpoint](#module\_vpc\_endpoint) | ../vpc-endpoint | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_vpc_attachment.tgw_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_network_acl.application_network_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.db_network_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl_rule.application_inbound_acl_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.application_outbound_acl_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.db_inbound_acl_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.db_outbound_acl_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_route.app_route_0_0_0_0_0](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.db_route_0_0_0_0_0](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.intra_route_0_0_0_0_0](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.application_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.db_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.application_route_table_with_AZs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.db_route_table_with_AZs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.application_private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.db_private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_env"></a> [client\_env](#input\_client\_env) | The environment specific to the client (e.g., 0000p, 0000t, etc...). | `string` | n/a | yes |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | The ID for the client. | `string` | n/a | yes |
| <a name="input_common"></a> [common](#input\_common) | Common prefix | `string` | n/a | yes |
| <a name="input_create_igw"></a> [create\_igw](#input\_create\_igw) | Whether to create an internet gateway for the VPC. | `bool` | n/a | yes |
| <a name="input_dhcp_options_domain_name"></a> [dhcp\_options\_domain\_name](#input\_dhcp\_options\_domain\_name) | AD Domain Name | `string` | n/a | yes |
| <a name="input_dhcp_options_domain_name_servers"></a> [dhcp\_options\_domain\_name\_servers](#input\_dhcp\_options\_domain\_name\_servers) | Array with the IPs of the name servers | `list(string)` | n/a | yes |
| <a name="input_enable_dhcp_options"></a> [enable\_dhcp\_options](#input\_enable\_dhcp\_options) | Boolean to indicate if we're going to use domain\_name and domain\_name\_servers | `bool` | n/a | yes |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Whether to enable the NAT gateway in the VPC. | `bool` | n/a | yes |
| <a name="input_env_domain"></a> [env\_domain](#input\_env\_domain) | The domain of this environment | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment specific configurations. | <pre>object({<br>    region                = string<br>    install_egress_access = bool<br>    vpc = object({<br>      cidr           = string<br>      enabled_azs    = list(string)<br>      public_subnets = list(string)<br>      intra_subnets  = list(string)<br>    })<br>    app_vpc = object({<br>      cidr                             = string<br>      enabled_azs                      = list(string)<br>      private_subnets_for_applications = list(string)<br>      private_subnets_for_dbs          = list(string)<br>      intra_subnets                    = list(string)<br>    })<br>    network_account_cidr = string<br>    nginx_config = object({<br>      instance_type = map(string)<br>      ami           = map(string)<br>    })<br>    halo_config = object({<br>      instance_type = map(string)<br>      ami           = map(string)<br>    })<br>    aura_config = object({<br>      instance_type = map(string)<br>      ami           = map(string)<br>    })<br>    core_config = object({<br>      number_of_secondary_ips = number<br>      instance_type           = map(string)<br>      ami                     = map(string)<br>    })<br>    mdb_config = object({<br>      number_of_secondary_ips = number<br>      instance_type           = map(string)<br>      ami                     = map(string)<br>    })<br>    rdb_config = object({<br>      number_of_secondary_ips = number<br>      instance_type           = map(string)<br>      ami                     = map(string)<br>    })<br>    workhours         = string<br>    out_of_workhours  = string<br>    delayed_workhours = string<br>  })</pre> | n/a | yes |
| <a name="input_global_vars"></a> [global\_vars](#input\_global\_vars) | Global variables that are common across the infrastructure. | `any` | n/a | yes |
| <a name="input_network_app_acls"></a> [network\_app\_acls](#input\_network\_app\_acls) | List of network access control lists for the application. | `any` | n/a | yes |
| <a name="input_tier"></a> [tier](#input\_tier) | Type of tier (tier1, tier2, tier3) | `string` | n/a | yes |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | ID of the transit gateway to attach to the VPC. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_route_table"></a> [app\_route\_table](#output\_app\_route\_table) | Application route table |
| <a name="output_app_subnet_ids_array"></a> [app\_subnet\_ids\_array](#output\_app\_subnet\_ids\_array) | An Array with all the IDs of the APP subnets |
| <a name="output_db_route_table"></a> [db\_route\_table](#output\_db\_route\_table) | DB route table |
| <a name="output_db_subnet_ids_array"></a> [db\_subnet\_ids\_array](#output\_db\_subnet\_ids\_array) | An Array with all the IDs of the DB subnets |
| <a name="output_tgw_att"></a> [tgw\_att](#output\_tgw\_att) | App VPC transit gateway attachment |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | CIDR Block for DMZ VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the APP VPC |
