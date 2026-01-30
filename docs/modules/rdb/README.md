## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_fsx_windows_file_system.fsx_for_rdb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_windows_file_system) | resource |
| [aws_instance.rdb_01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.rdb_02](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_network_interface.rdb_01_primary_nic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_network_interface.rdb_02_primary_nic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bia_risk"></a> [bia\_risk](#input\_bia\_risk) | BIA rating of asset for Business Continuity or DR purposes | `string` | n/a | yes |
| <a name="input_cia_risk"></a> [cia\_risk](#input\_cia\_risk) | CIA rating of asset for Information Security purposes | `string` | n/a | yes |
| <a name="input_client_env"></a> [client\_env](#input\_client\_env) | The environment specific to the client (e.g., 0000p, 0000t, etc...). | `string` | n/a | yes |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | The ID for the client. | `string` | n/a | yes |
| <a name="input_common"></a> [common](#input\_common) | Common prefix | `string` | n/a | yes |
| <a name="input_data_classification"></a> [data\_classification](#input\_data\_classification) | Data Rating as per Lendscape Policy | `string` | n/a | yes |
| <a name="input_db_subnet_ids_array"></a> [db\_subnet\_ids\_array](#input\_db\_subnet\_ids\_array) | An array with all the db subnets ids | `list(string)` | n/a | yes |
| <a name="input_directory_id"></a> [directory\_id](#input\_directory\_id) | Directory ID | `string` | n/a | yes |
| <a name="input_env_domain"></a> [env\_domain](#input\_env\_domain) | The domain of this environment | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment specific configurations. | <pre>object({<br>    region                = string<br>    install_egress_access = bool<br>    vpc = object({<br>      cidr           = string<br>      enabled_azs    = list(string)<br>      public_subnets = list(string)<br>      intra_subnets  = list(string)<br>    })<br>    app_vpc = object({<br>      cidr                             = string<br>      enabled_azs                      = list(string)<br>      private_subnets_for_applications = list(string)<br>      private_subnets_for_dbs          = list(string)<br>      intra_subnets                    = list(string)<br>    })<br>    network_account_cidr = string<br>    nginx_config = object({<br>      instance_type = map(string)<br>      ami           = map(string)<br>    })<br>    halo_config = object({<br>      instance_type = map(string)<br>      ami           = map(string)<br>    })<br>    aura_config = object({<br>      instance_type = map(string)<br>      ami           = map(string)<br>    })<br>    core_config = object({<br>      number_of_secondary_ips = number<br>      instance_type           = map(string)<br>      ami                     = map(string)<br>      fsx_storage_type        = string<br>      fsx_storage_capacity    = number<br>      fsx_throughput_capacity = number<br>      fsx_deployment_type     = string<br>    })<br>    mdb_config = object({<br>      number_of_secondary_ips = number<br>      instance_type           = map(string)<br>      ami                     = map(string)<br>      create_fsx              = bool<br>      fsx_storage_type        = string<br>      fsx_storage_capacity    = number<br>      fsx_throughput_capacity = number<br>      fsx_deployment_type     = string<br>    })<br>    rdb_config = object({<br>      number_of_secondary_ips = number<br>      instance_type           = map(string)<br>      ami                     = map(string)<br>      create_fsx              = bool<br>      fsx_storage_type        = string<br>      fsx_storage_capacity    = number<br>      fsx_throughput_capacity = number<br>      fsx_deployment_type     = string<br>    })<br>    workhours         = string<br>    out_of_workhours  = string<br>    delayed_workhours = string<br>  })</pre> | n/a | yes |
| <a name="input_fsx_subnet_id"></a> [fsx\_subnet\_id](#input\_fsx\_subnet\_id) | FSX Subnet ID as a string to mount the AD | `string` | n/a | yes |
| <a name="input_gen_fsx_security_group_id"></a> [gen\_fsx\_security\_group\_id](#input\_gen\_fsx\_security\_group\_id) | ID of the General FSX Security Group | `string` | n/a | yes |
| <a name="input_global_vars"></a> [global\_vars](#input\_global\_vars) | Global variables that are common across the infrastructure. | `any` | n/a | yes |
| <a name="input_jenkins_sgp"></a> [jenkins\_sgp](#input\_jenkins\_sgp) | The security group to allow jenkins CICD connections | `string` | n/a | yes |
| <a name="input_management_security_group_id"></a> [management\_security\_group\_id](#input\_management\_security\_group\_id) | ID of the Management Security Group | `string` | n/a | yes |
| <a name="input_rdb_fsx_security_group_id"></a> [rdb\_fsx\_security\_group\_id](#input\_rdb\_fsx\_security\_group\_id) | ID of the RDB FSX Security Group | `string` | n/a | yes |
| <a name="input_rdb_security_group_id"></a> [rdb\_security\_group\_id](#input\_rdb\_security\_group\_id) | ID of the RDB Security Group | `string` | n/a | yes |
| <a name="input_ssm_instance_profile"></a> [ssm\_instance\_profile](#input\_ssm\_instance\_profile) | The IAM instance profile required for SSM | `any` | n/a | yes |
| <a name="input_tier"></a> [tier](#input\_tier) | Type of tier (tier1, tier2, tier3) | `string` | n/a | yes |

## Outputs

No outputs.
