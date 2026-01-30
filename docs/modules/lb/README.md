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
| [aws_lb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb.nlb_aura](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb.nlb_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb.nlb_halo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.alb_public_https_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.nlb_aura_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.nlb_core_api_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.nlb_core_hazelcast_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.nlb_core_jms_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.nlb_halo_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.alb_listener_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_security_group_id"></a> [alb\_security\_group\_id](#input\_alb\_security\_group\_id) | ID of the ALB Security Group | `string` | n/a | yes |
| <a name="input_alb_target_group_arn"></a> [alb\_target\_group\_arn](#input\_alb\_target\_group\_arn) | The ARN of the ALB Target Group | `string` | n/a | yes |
| <a name="input_app_subnet_ids_array"></a> [app\_subnet\_ids\_array](#input\_app\_subnet\_ids\_array) | n/a | `any` | n/a | yes |
| <a name="input_client_env"></a> [client\_env](#input\_client\_env) | The environment specific to the client (e.g., 0000p, 0000t, etc...). | `string` | n/a | yes |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | The ID for the client. | `string` | n/a | yes |
| <a name="input_common"></a> [common](#input\_common) | Common prefix | `string` | n/a | yes |
| <a name="input_env_domain"></a> [env\_domain](#input\_env\_domain) | The domain of this environment | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment specific configurations. | <pre>object({<br>    region                = string<br>    install_egress_access = bool<br>    vpc = object({<br>      cidr           = string<br>      enabled_azs    = list(string)<br>      public_subnets = list(string)<br>      intra_subnets  = list(string)<br>    })<br>    app_vpc = object({<br>      cidr                             = string<br>      enabled_azs                      = list(string)<br>      private_subnets_for_applications = list(string)<br>      private_subnets_for_dbs          = list(string)<br>      intra_subnets                    = list(string)<br>    })<br>    network_account_cidr = string<br>    nginx_config = object({<br>      instance_type = map(string)<br>      ami           = map(string)<br>    })<br>    halo_config = object({<br>      instance_type = map(string)<br>      ami           = map(string)<br>    })<br>    aura_config = object({<br>      instance_type = map(string)<br>      ami           = map(string)<br>    })<br>    core_config = object({<br>      number_of_secondary_ips = number<br>      instance_type           = map(string)<br>      ami                     = map(string)<br>    })<br>    mdb_config = object({<br>      number_of_secondary_ips = number<br>      instance_type           = map(string)<br>      ami                     = map(string)<br>    })<br>    rdb_config = object({<br>      number_of_secondary_ips = number<br>      instance_type           = map(string)<br>      ami                     = map(string)<br>    })<br>    workhours         = string<br>    out_of_workhours  = string<br>    delayed_workhours = string<br>  })</pre> | n/a | yes |
| <a name="input_global_vars"></a> [global\_vars](#input\_global\_vars) | Global variables that are common across the infrastructure. | `any` | n/a | yes |
| <a name="input_nlb_aura_security_group_id"></a> [nlb\_aura\_security\_group\_id](#input\_nlb\_aura\_security\_group\_id) | ID of the NLB Aura Security Group | `string` | n/a | yes |
| <a name="input_nlb_aura_target_group_arn"></a> [nlb\_aura\_target\_group\_arn](#input\_nlb\_aura\_target\_group\_arn) | The ARN of the NLB Aura Target Group | `string` | n/a | yes |
| <a name="input_nlb_core_security_group_id"></a> [nlb\_core\_security\_group\_id](#input\_nlb\_core\_security\_group\_id) | ID of the NLB Core Security Group | `string` | n/a | yes |
| <a name="input_nlb_core_targets_group_arn"></a> [nlb\_core\_targets\_group\_arn](#input\_nlb\_core\_targets\_group\_arn) | The ARNs of the NLB Core Target Groups | `map(string)` | n/a | yes |
| <a name="input_nlb_halo_security_group_id"></a> [nlb\_halo\_security\_group\_id](#input\_nlb\_halo\_security\_group\_id) | ID of the NLB Halo Security Group | `string` | n/a | yes |
| <a name="input_nlb_halo_target_group_arn"></a> [nlb\_halo\_target\_group\_arn](#input\_nlb\_halo\_target\_group\_arn) | The ARN of the NLB Halo Target Group | `string` | n/a | yes |
| <a name="input_public_subnet_ids_array"></a> [public\_subnet\_ids\_array](#input\_public\_subnet\_ids\_array) | n/a | `any` | n/a | yes |
| <a name="input_tier"></a> [tier](#input\_tier) | Type of tier (tier1, tier2, tier3) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | The ARN of the ALB |
