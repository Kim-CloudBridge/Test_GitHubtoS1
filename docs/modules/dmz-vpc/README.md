## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.1.2 |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_vpc_attachment.tgw_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_route.public_route_0_0_0_0_0](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.route_10_210_50_0_24](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_env"></a> [client\_env](#input\_client\_env) | The environment specific to the client (e.g., 0000p, 0000t, etc...). | `string` | n/a | yes |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | The ID for the client. | `string` | n/a | yes |
| <a name="input_common"></a> [common](#input\_common) | Common prefix | `string` | n/a | yes |
| <a name="input_create_igw"></a> [create\_igw](#input\_create\_igw) | Whether to create an internet gateway for the VPC. | `bool` | n/a | yes |
| <a name="input_dhcp_options_domain_name"></a> [dhcp\_options\_domain\_name](#input\_dhcp\_options\_domain\_name) | AD Domain Name | `string` | `""` | no |
| <a name="input_dhcp_options_domain_name_servers"></a> [dhcp\_options\_domain\_name\_servers](#input\_dhcp\_options\_domain\_name\_servers) | Array with the IPs of the name servers | `list(string)` | <pre>[<br>  "AmazonProvidedDNS"<br>]</pre> | no |
| <a name="input_enable_dhcp_options"></a> [enable\_dhcp\_options](#input\_enable\_dhcp\_options) | Boolean to indicate if we're going to use domain\_name and domain\_name\_servers | `bool` | n/a | yes |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Whether to enable the NAT gateway in the VPC. | `bool` | n/a | yes |
| <a name="input_env_domain"></a> [env\_domain](#input\_env\_domain) | The domain of this environment | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment specific configurations. | <pre>object({<br>    region                = string<br>    install_egress_access = bool<br>    vpc = object({<br>      cidr           = string<br>      enabled_azs    = list(string)<br>      public_subnets = list(string)<br>      intra_subnets  = list(string)<br>    })<br>    app_vpc = object({<br>      cidr                             = string<br>      enabled_azs                      = list(string)<br>      private_subnets_for_applications = list(string)<br>      private_subnets_for_dbs          = list(string)<br>      intra_subnets                    = list(string)<br>    })<br>    network_account_cidr = string<br>    nginx_config = object({<br>      instance_type = map(string)<br>      ami           = map(string)<br>    })<br>    halo_config = object({<br>      instance_type = map(string)<br>      ami           = map(string)<br>    })<br>    aura_config = object({<br>      instance_type = map(string)<br>      ami           = map(string)<br>    })<br>    core_config = object({<br>      number_of_secondary_ips = number<br>      instance_type           = map(string)<br>      ami                     = map(string)<br>    })<br>    mdb_config = object({<br>      number_of_secondary_ips = number<br>      instance_type           = map(string)<br>      ami                     = map(string)<br>    })<br>    rdb_config = object({<br>      number_of_secondary_ips = number<br>      instance_type           = map(string)<br>      ami                     = map(string)<br>    })<br>    workhours         = string<br>    out_of_workhours  = string<br>    delayed_workhours = string<br>  })</pre> | n/a | yes |
| <a name="input_global_vars"></a> [global\_vars](#input\_global\_vars) | n/a | `any` | n/a | yes |
| <a name="input_network_acls_dmz"></a> [network\_acls\_dmz](#input\_network\_acls\_dmz) | List of network access control lists for the DMZ. | `any` | n/a | yes |
| <a name="input_tier"></a> [tier](#input\_tier) | Type of tier (tier1, tier2, tier3) | `string` | n/a | yes |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | ID of the transit gateway to attach to the VPC. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_intra_route_table_ids"></a> [intra\_route\_table\_ids](#output\_intra\_route\_table\_ids) | Intra route table |
| <a name="output_private_subnet_ids_array"></a> [private\_subnet\_ids\_array](#output\_private\_subnet\_ids\_array) | An Array with all the IDs of the public subnets |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | Public route table |
| <a name="output_public_subnet_ids_array"></a> [public\_subnet\_ids\_array](#output\_public\_subnet\_ids\_array) | An Array with all the IDs of the public subnets |
| <a name="output_tgw_att"></a> [tgw\_att](#output\_tgw\_att) | App VPC transit gateway attachment |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | CIDR Block for DMZ VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
