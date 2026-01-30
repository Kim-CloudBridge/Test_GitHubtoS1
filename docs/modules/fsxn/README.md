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
| [aws_fsx_ontap_file_system.fsxn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_ontap_file_system) | resource |
| [aws_fsx_ontap_storage_virtual_machine.core_fsxn_svm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_ontap_storage_virtual_machine) | resource |
| [aws_fsx_ontap_storage_virtual_machine.mdb_fsxn_svm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_ontap_storage_virtual_machine) | resource |
| [aws_fsx_ontap_storage_virtual_machine.rdb_fsxn_svm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_ontap_storage_virtual_machine) | resource |
| [aws_fsx_ontap_volume.core_fsxn_volume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_ontap_volume) | resource |
| [aws_fsx_ontap_volume.mdb_fsxn_volume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_ontap_volume) | resource |
| [aws_fsx_ontap_volume.rdb_fsxn_volume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_ontap_volume) | resource |
| [aws_directory_service_directory.my_domain_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/directory_service_directory) | data source |
| [aws_subnet.fsx_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ad_config"></a> [ad\_config](#input\_ad\_config) | AD Configuration to supply to FSxN SVM | <pre>object({<br>    directory_id                           = string<br>    service_account_password               = string<br>    service_account_user                   = string<br>    file_system_administrators_group       = string<br>    organizational_unit_distinguished_name = string<br>  })</pre> | n/a | yes |
| <a name="input_client_env"></a> [client\_env](#input\_client\_env) | The environment specific to the client (e.g., 0000p, 0000t, etc...). | `string` | n/a | yes |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | The ID for the client. | `string` | n/a | yes |
| <a name="input_common"></a> [common](#input\_common) | Common prefix | `string` | n/a | yes |
| <a name="input_env_domain"></a> [env\_domain](#input\_env\_domain) | The domain of this environment | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment specific configurations. | <pre>object({<br>    region                = string<br>    install_egress_access = bool<br>    vpc = object({<br>      cidr           = string<br>      enabled_azs    = list(string)<br>      public_subnets = list(string)<br>      intra_subnets  = list(string)<br>    })<br>    app_vpc = object({<br>      cidr                             = string<br>      enabled_azs                      = list(string)<br>      private_subnets_for_applications = list(string)<br>      private_subnets_for_dbs          = list(string)<br>      intra_subnets                    = list(string)<br>    })<br>    network_account_cidr = string<br>    nginx_config = object({<br>      instance_type = map(string)<br>      ami           = map(string)<br>    })<br>    halo_config = object({<br>      instance_type = map(string)<br>      ami           = map(string)<br>    })<br>    aura_config = object({<br>      instance_type = map(string)<br>      ami           = map(string)<br>    })<br>    core_config = object({<br>      number_of_secondary_ips = number<br>      instance_type           = map(string)<br>      ami                     = map(string)<br>      fsx_storage_type        = string<br>      fsx_storage_capacity    = number<br>      fsx_throughput_capacity = number<br>      fsx_deployment_type     = string<br>    })<br>    mdb_config = object({<br>      number_of_secondary_ips = number<br>      instance_type           = map(string)<br>      ami                     = map(string)<br>      fsx_storage_type        = string<br>      fsx_storage_capacity    = number<br>      fsx_throughput_capacity = number<br>      fsx_deployment_type     = string<br>    })<br>    rdb_config = object({<br>      number_of_secondary_ips = number<br>      instance_type           = map(string)<br>      ami                     = map(string)<br>      fsx_storage_type        = string<br>      fsx_storage_capacity    = number<br>      fsx_throughput_capacity = number<br>      fsx_deployment_type     = string<br>    })<br>    workhours         = string<br>    out_of_workhours  = string<br>    delayed_workhours = string<br>  })</pre> | n/a | yes |
| <a name="input_environment_fsxn_config"></a> [environment\_fsxn\_config](#input\_environment\_fsxn\_config) | the fsxn configuration | <pre>object({<br>    fsx_deployment_type = string<br>    storage_type        = string<br>    storage_capacity    = string<br>    throughput_capacity = string<br>    # endpoint_ip_range   = string<br>    disk_iops_configuration = object(<br>      {<br>        iops = string<br>        mode = string<br>    })<br>    ontap_volume_type = string<br>    volume_sizes = object({<br>      rdb = number<br>      mdb = number<br>      core = number<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_fsx_preferred_subnet_id"></a> [fsx\_preferred\_subnet\_id](#input\_fsx\_preferred\_subnet\_id) | FSX Subnet ID as a string to mount the AD | `string` | n/a | yes |
| <a name="input_fsx_route_table_ids"></a> [fsx\_route\_table\_ids](#input\_fsx\_route\_table\_ids) | List of Route Table ID as strings where FSxN endpoints will be created | `list(string)` | n/a | yes |
| <a name="input_fsx_security_group_id"></a> [fsx\_security\_group\_id](#input\_fsx\_security\_group\_id) | ID of the FSXN Security Group | `string` | n/a | yes |
| <a name="input_fsx_subnet_id"></a> [fsx\_subnet\_id](#input\_fsx\_subnet\_id) | FSX Subnet ID as a string to mount the AD | `list(string)` | n/a | yes |
| <a name="input_gen_fsx_security_group_id"></a> [gen\_fsx\_security\_group\_id](#input\_gen\_fsx\_security\_group\_id) | ID of the General FSX Security Group | `string` | n/a | yes |
| <a name="input_global_vars"></a> [global\_vars](#input\_global\_vars) | Global variables that are common across the infrastructure. | `any` | n/a | yes |
| <a name="input_tier"></a> [tier](#input\_tier) | Type of tier (tier1, tier2, tier3) | `string` | n/a | yes |

## Outputs

No outputs.
