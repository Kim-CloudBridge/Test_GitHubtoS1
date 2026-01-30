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
| [aws_security_group.nginx_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.alb_dynamic_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.alb_dynamic_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.alb_egress_to_nginx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nginx_dynamic_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nginx_dynamic_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nginx_ingress_from_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nginx_tcp_egress_internet_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nginx_tcp_egress_private_network_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_security_group_egress_rules"></a> [alb\_security\_group\_egress\_rules](#input\_alb\_security\_group\_egress\_rules) | ALB Extension Egress Rules | `list(any)` | n/a | yes |
| <a name="input_alb_security_group_ingress_rules"></a> [alb\_security\_group\_ingress\_rules](#input\_alb\_security\_group\_ingress\_rules) | ALB Extension Ingress Rules | `list(any)` | n/a | yes |
| <a name="input_client_env"></a> [client\_env](#input\_client\_env) | n/a | `string` | n/a | yes |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | n/a | `string` | n/a | yes |
| <a name="input_common"></a> [common](#input\_common) | n/a | `string` | n/a | yes |
| <a name="input_dmz_vpc"></a> [dmz\_vpc](#input\_dmz\_vpc) | n/a | `map(any)` | n/a | yes |
| <a name="input_env_domain"></a> [env\_domain](#input\_env\_domain) | n/a | `string` | n/a | yes |
| <a name="input_global_vars"></a> [global\_vars](#input\_global\_vars) | n/a | `any` | n/a | yes |
| <a name="input_nginx_security_group_egress_rules"></a> [nginx\_security\_group\_egress\_rules](#input\_nginx\_security\_group\_egress\_rules) | Nginx Extension Egress Rules | `list(any)` | n/a | yes |
| <a name="input_nginx_security_group_ingress_rules"></a> [nginx\_security\_group\_ingress\_rules](#input\_nginx\_security\_group\_ingress\_rules) | Nginx Extension Ingress Rules | `list(any)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_tier"></a> [tier](#input\_tier) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_security_group_id"></a> [alb\_security\_group\_id](#output\_alb\_security\_group\_id) | n/a |
| <a name="output_nginx_security_group_id"></a> [nginx\_security\_group\_id](#output\_nginx\_security\_group\_id) | n/a |
