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
| [aws_security_group.alb_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.appstream_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.aura_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.core_fsx_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.core_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.fsx_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.halo_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.management_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.mdb_fsx_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.mdb_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.nginx_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.nlb_aura_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.nlb_core_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.nlb_halo_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.rdb_fsx_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.rdb_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.alb_dynamic_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.alb_dynamic_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.alb_egress_to_nginx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.appstream_tcp_egress_internet_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.appstream_to_core_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.appstream_to_nlb_core_ingress_smb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.aura_dynamic_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.aura_dynamic_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.core_dynamic_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.core_dynamic_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.core_fsx_dynamic_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.core_fsx_dynamic_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.core_fsx_ingress_mdb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.core_fsx_ingress_rdb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.core_fsx_ingress_smb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.core_ingress_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.core_ingress_hazelcast](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.core_ingress_jms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.core_ingress_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress_core_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress_mdb_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress_rdb_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elb_egress_core_to_mdb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elb_egress_core_to_nlb_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elb_egress_core_to_rdb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elb_egress_hazelcast_to_lendscape_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elb_egress_hazelcast_to_lendscape_core_second](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elb_egress_http_to_lendscape_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elb_egress_jms_to_lendscape_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elb_egress_to_aura_elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elb_egress_to_halo_elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elb_ingress_core_to_nlb_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elb_ingress_to_aura](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elb_ingress_to_halo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.fsx_egress_ad_ds_powershell](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.fsx_egress_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.fsx_egress_dns_udp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.fsx_egress_kerberos_udp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.fsx_egress_ldap_udp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.fsx_egress_ntp_udp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.fsx_egress_password_udp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.fsx_egress_rpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.fsx_egress_tcp_135](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.fsx_egress_tcp_464](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.fsx_egress_tcp_kerberos](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.fsx_egress_tcp_ldap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.fsx_egress_tcp_ldaps](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.fsx_egress_tcp_mgc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.fsx_egress_tcp_smb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.fsx_ingress_dns_tcp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.fsx_ingress_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.fsx_ingress_tcp_udp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.fsx_ingress_winrm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.halo_dynamic_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.halo_dynamic_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.management_dynamic_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.management_dynamic_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.management_rdp_ingress_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.management_ssh_ingress_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.mdb_dynamic_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.mdb_dynamic_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.mdb_fsx_dynamic_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.mdb_fsx_dynamic_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.mdb_fsx_ingress_smb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.mdb_ingress_mssql_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.mdb_ingress_mssql_network_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.mdb_ingress_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.network_account_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nginx_dynamic_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nginx_dynamic_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nginx_ingress_from_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nginx_tcp_egress_internet_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nginx_tcp_egress_private_network_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nlb_aura_dynamic_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nlb_aura_dynamic_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nlb_aura_ingress_dmz](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nlb_aura_ingress_network_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nlb_core_allow_aura_hazelcast](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nlb_core_allow_aura_jms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nlb_core_allow_halo_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nlb_core_allow_halo_hazelcast](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nlb_core_dynamic_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nlb_core_dynamic_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nlb_halo_dynamic_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nlb_halo_dynamic_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rdb_dynamic_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rdb_dynamic_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rdb_fsx_dynamic_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rdb_fsx_dynamic_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rdb_fsx_ingress_smb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rdb_ingress_mssql_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rdb_ingress_mssql_network_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rdb_ingress_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ad_cidr"></a> [ad\_cidr](#input\_ad\_cidr) | IP CIDRs of the AD directory | `list(any)` | n/a | yes |
| <a name="input_alb_security_group_egress_rules"></a> [alb\_security\_group\_egress\_rules](#input\_alb\_security\_group\_egress\_rules) | ALB Extension Egress Rules | `list(any)` | n/a | yes |
| <a name="input_alb_security_group_ingress_rules"></a> [alb\_security\_group\_ingress\_rules](#input\_alb\_security\_group\_ingress\_rules) | ALB Extension Ingress Rules | `list(any)` | n/a | yes |
| <a name="input_app_vpc"></a> [app\_vpc](#input\_app\_vpc) | APP VPC module | `any` | n/a | yes |
| <a name="input_aura_security_group_egress_rules"></a> [aura\_security\_group\_egress\_rules](#input\_aura\_security\_group\_egress\_rules) | Aura Extension Egress Rules | `list(any)` | n/a | yes |
| <a name="input_aura_security_group_ingress_rules"></a> [aura\_security\_group\_ingress\_rules](#input\_aura\_security\_group\_ingress\_rules) | Aura Extension Ingress Rules | `list(any)` | n/a | yes |
| <a name="input_client_env"></a> [client\_env](#input\_client\_env) | The environment specific to the client (e.g., 0000p, 0000t, etc...). | `string` | n/a | yes |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | The ID for the client. | `string` | n/a | yes |
| <a name="input_common"></a> [common](#input\_common) | Common prefix | `string` | n/a | yes |
| <a name="input_core_fsx_security_group_egress_rules"></a> [core\_fsx\_security\_group\_egress\_rules](#input\_core\_fsx\_security\_group\_egress\_rules) | Core's FSX Extension Egress Rules | `list(any)` | n/a | yes |
| <a name="input_core_fsx_security_group_ingress_rules"></a> [core\_fsx\_security\_group\_ingress\_rules](#input\_core\_fsx\_security\_group\_ingress\_rules) | Core's FSX Extension Ingress Rules | `list(any)` | n/a | yes |
| <a name="input_core_security_group_egress_rules"></a> [core\_security\_group\_egress\_rules](#input\_core\_security\_group\_egress\_rules) | Core Extension Egress Rules | `list(any)` | n/a | yes |
| <a name="input_core_security_group_ingress_rules"></a> [core\_security\_group\_ingress\_rules](#input\_core\_security\_group\_ingress\_rules) | Core Extension Ingress Rules | `list(any)` | n/a | yes |
| <a name="input_dmz_vpc"></a> [dmz\_vpc](#input\_dmz\_vpc) | DMZ VPC module | `any` | n/a | yes |
| <a name="input_enable_appstream"></a> [enable\_appstream](#input\_enable\_appstream) | Flag to create AppStream security group and attach it to Core NLB | `bool` | n/a | yes |
| <a name="input_env_domain"></a> [env\_domain](#input\_env\_domain) | The domain of this environment | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment specific configurations. | <pre>object({<br>    region                = string<br>    install_egress_access = bool<br>    vpc = object({<br>      cidr           = string<br>      enabled_azs    = list(string)<br>      public_subnets = list(string)<br>      intra_subnets  = list(string)<br>    })<br>    app_vpc = object({<br>      cidr                             = string<br>      enabled_azs                      = list(string)<br>      private_subnets_for_applications = list(string)<br>      private_subnets_for_dbs          = list(string)<br>      intra_subnets                    = list(string)<br>    })<br>    network_account_cidr = string<br>    nginx_config = object({<br>      instance_type = map(string)<br>      ami           = map(string)<br>    })<br>    halo_config = object({<br>      instance_type = map(string)<br>      ami           = map(string)<br>    })<br>    aura_config = object({<br>      instance_type = map(string)<br>      ami           = map(string)<br>    })<br>    core_config = object({<br>      number_of_secondary_ips = number<br>      instance_type           = map(string)<br>      ami                     = map(string)<br>    })<br>    mdb_config = object({<br>      number_of_secondary_ips = number<br>      instance_type           = map(string)<br>      ami                     = map(string)<br>    })<br>    rdb_config = object({<br>      number_of_secondary_ips = number<br>      instance_type           = map(string)<br>      ami                     = map(string)<br>    })<br>    workhours         = string<br>    out_of_workhours  = string<br>    delayed_workhours = string<br>  })</pre> | n/a | yes |
| <a name="input_ew_fw_cidr"></a> [ew\_fw\_cidr](#input\_ew\_fw\_cidr) | IP CIDRs of the E/W firewall | `list(any)` | n/a | yes |
| <a name="input_global_vars"></a> [global\_vars](#input\_global\_vars) | Global variables that are common across the infrastructure. | `any` | n/a | yes |
| <a name="input_halo_security_group_egress_rules"></a> [halo\_security\_group\_egress\_rules](#input\_halo\_security\_group\_egress\_rules) | Halo Extension Egress Rules | `list(any)` | n/a | yes |
| <a name="input_halo_security_group_ingress_rules"></a> [halo\_security\_group\_ingress\_rules](#input\_halo\_security\_group\_ingress\_rules) | Halo Extension Ingress Rules | `list(any)` | n/a | yes |
| <a name="input_management_security_group_egress_rules"></a> [management\_security\_group\_egress\_rules](#input\_management\_security\_group\_egress\_rules) | Management Extension Ingress Rules | `list(any)` | n/a | yes |
| <a name="input_management_security_group_ingress_rules"></a> [management\_security\_group\_ingress\_rules](#input\_management\_security\_group\_ingress\_rules) | Management Extension Ingress Rules | `list(any)` | n/a | yes |
| <a name="input_mdb_fsx_security_group_egress_rules"></a> [mdb\_fsx\_security\_group\_egress\_rules](#input\_mdb\_fsx\_security\_group\_egress\_rules) | MDB's FSX Extension Egress Rules | `list(any)` | n/a | yes |
| <a name="input_mdb_fsx_security_group_ingress_rules"></a> [mdb\_fsx\_security\_group\_ingress\_rules](#input\_mdb\_fsx\_security\_group\_ingress\_rules) | MDB's FSX Extension Ingress Rules | `list(any)` | n/a | yes |
| <a name="input_mdb_security_group_egress_rules"></a> [mdb\_security\_group\_egress\_rules](#input\_mdb\_security\_group\_egress\_rules) | MDB Extension Egress Rules | `list(any)` | n/a | yes |
| <a name="input_mdb_security_group_ingress_rules"></a> [mdb\_security\_group\_ingress\_rules](#input\_mdb\_security\_group\_ingress\_rules) | MDB Extension Ingress Rules | `list(any)` | n/a | yes |
| <a name="input_nginx_security_group_egress_rules"></a> [nginx\_security\_group\_egress\_rules](#input\_nginx\_security\_group\_egress\_rules) | Nginx Extension Egress Rules | `list(any)` | n/a | yes |
| <a name="input_nginx_security_group_ingress_rules"></a> [nginx\_security\_group\_ingress\_rules](#input\_nginx\_security\_group\_ingress\_rules) | Nginx Extension Ingress Rules | `list(any)` | n/a | yes |
| <a name="input_nlb_aura_security_group_egress_rules"></a> [nlb\_aura\_security\_group\_egress\_rules](#input\_nlb\_aura\_security\_group\_egress\_rules) | NLB Halo Extension Egress Rules | `list(any)` | n/a | yes |
| <a name="input_nlb_aura_security_group_ingress_rules"></a> [nlb\_aura\_security\_group\_ingress\_rules](#input\_nlb\_aura\_security\_group\_ingress\_rules) | NLB Aura Extension Ingress Rules | `list(any)` | n/a | yes |
| <a name="input_nlb_core_security_group_egress_rules"></a> [nlb\_core\_security\_group\_egress\_rules](#input\_nlb\_core\_security\_group\_egress\_rules) | NLB Core Extension Egress Rules | `list(any)` | n/a | yes |
| <a name="input_nlb_core_security_group_ingress_rules"></a> [nlb\_core\_security\_group\_ingress\_rules](#input\_nlb\_core\_security\_group\_ingress\_rules) | NLB Core Extension Ingress Rules | `list(any)` | n/a | yes |
| <a name="input_nlb_halo_security_group_egress_rules"></a> [nlb\_halo\_security\_group\_egress\_rules](#input\_nlb\_halo\_security\_group\_egress\_rules) | NLB Halo Extension Egress Rules | `list(any)` | n/a | yes |
| <a name="input_nlb_halo_security_group_ingress_rules"></a> [nlb\_halo\_security\_group\_ingress\_rules](#input\_nlb\_halo\_security\_group\_ingress\_rules) | NLB Halo Extension Ingress Rules | `list(any)` | n/a | yes |
| <a name="input_rdb_fsx_security_group_egress_rules"></a> [rdb\_fsx\_security\_group\_egress\_rules](#input\_rdb\_fsx\_security\_group\_egress\_rules) | RDB's FSX Extension Egress Rules | `list(any)` | n/a | yes |
| <a name="input_rdb_fsx_security_group_ingress_rules"></a> [rdb\_fsx\_security\_group\_ingress\_rules](#input\_rdb\_fsx\_security\_group\_ingress\_rules) | RDB's FSX Extension Ingress Rules | `list(any)` | n/a | yes |
| <a name="input_rdb_security_group_egress_rules"></a> [rdb\_security\_group\_egress\_rules](#input\_rdb\_security\_group\_egress\_rules) | RDB Extension Egress Rules | `list(any)` | n/a | yes |
| <a name="input_rdb_security_group_ingress_rules"></a> [rdb\_security\_group\_ingress\_rules](#input\_rdb\_security\_group\_ingress\_rules) | RDB Extension Ingress Rules | `list(any)` | n/a | yes |
| <a name="input_tier"></a> [tier](#input\_tier) | Type of tier (tier1, tier2, tier3) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_security_group_id"></a> [alb\_security\_group\_id](#output\_alb\_security\_group\_id) | The ID of the ALB Security Group |
| <a name="output_appstream_security_group"></a> [appstream\_security\_group](#output\_appstream\_security\_group) | Full Security Group for dependency resolution |
| <a name="output_appstream_security_group_id"></a> [appstream\_security\_group\_id](#output\_appstream\_security\_group\_id) | The ID of AppStream Security Group |
| <a name="output_aura_security_group_id"></a> [aura\_security\_group\_id](#output\_aura\_security\_group\_id) | The ID of AURA Security Group |
| <a name="output_core_fsx_security_group_id"></a> [core\_fsx\_security\_group\_id](#output\_core\_fsx\_security\_group\_id) | The ID of Core's FSX Security Group |
| <a name="output_core_security_group_id"></a> [core\_security\_group\_id](#output\_core\_security\_group\_id) | The ID of LS-CORE Security Group |
| <a name="output_gen_fsx_security_group_id"></a> [gen\_fsx\_security\_group\_id](#output\_gen\_fsx\_security\_group\_id) | The ID of general FSX Security Group rule |
| <a name="output_halo_security_group_id"></a> [halo\_security\_group\_id](#output\_halo\_security\_group\_id) | The ID of HALO Security Group |
| <a name="output_management_security_group_id"></a> [management\_security\_group\_id](#output\_management\_security\_group\_id) | The ID of Management Security Group |
| <a name="output_mdb_fsx_security_group_id"></a> [mdb\_fsx\_security\_group\_id](#output\_mdb\_fsx\_security\_group\_id) | The ID of MDB's FSX Security Group |
| <a name="output_mdb_security_group_id"></a> [mdb\_security\_group\_id](#output\_mdb\_security\_group\_id) | The ID of M-DB Security Group |
| <a name="output_nginx_security_group_id"></a> [nginx\_security\_group\_id](#output\_nginx\_security\_group\_id) | The ID of the nginx Security Group |
| <a name="output_nlb_aura_security_group_id"></a> [nlb\_aura\_security\_group\_id](#output\_nlb\_aura\_security\_group\_id) | The ID of the NLB AURA Security Group |
| <a name="output_nlb_core_security_group_id"></a> [nlb\_core\_security\_group\_id](#output\_nlb\_core\_security\_group\_id) | The ID of the NLB Core Security Group |
| <a name="output_nlb_halo_security_group_id"></a> [nlb\_halo\_security\_group\_id](#output\_nlb\_halo\_security\_group\_id) | The ID of the NLB HALO Security Group |
| <a name="output_rdb_fsx_security_group_id"></a> [rdb\_fsx\_security\_group\_id](#output\_rdb\_fsx\_security\_group\_id) | The ID of RDB's FSX Security Group |
| <a name="output_rdb_security_group_id"></a> [rdb\_security\_group\_id](#output\_rdb\_security\_group\_id) | The ID of R-DB Security Group |
