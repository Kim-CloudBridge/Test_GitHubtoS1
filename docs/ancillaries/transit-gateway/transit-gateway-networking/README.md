## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_core"></a> [core](#module\_core) | ../../../modules/transit-gateway-routing | n/a |
| <a name="module_dx-vpn"></a> [dx-vpn](#module\_dx-vpn) | ../../../modules/transit-gateway-routing | n/a |
| <a name="module_ew-insp"></a> [ew-insp](#module\_ew-insp) | ../../../modules/transit-gateway-routing | n/a |
| <a name="module_globalvars"></a> [globalvars](#module\_globalvars) | ../../../tf-global | n/a |
| <a name="module_ns-insp"></a> [ns-insp](#module\_ns-insp) | ../../../modules/transit-gateway-routing | n/a |
| <a name="module_prod-apps"></a> [prod-apps](#module\_prod-apps) | ../../../modules/transit-gateway-routing | n/a |
| <a name="module_prod-dmz"></a> [prod-dmz](#module\_prod-dmz) | ../../../modules/transit-gateway-routing | n/a |
| <a name="module_test-apps"></a> [test-apps](#module\_test-apps) | ../../../modules/transit-gateway-routing | n/a |
| <a name="module_test-dmz"></a> [test-dmz](#module\_test-dmz) | ../../../modules/transit-gateway-routing | n/a |
| <a name="module_transit_gateway_route_tables"></a> [transit\_gateway\_route\_tables](#module\_transit\_gateway\_route\_tables) | ../../../modules/transit-gateway-route-tables | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_dx_gateway_attachment.network](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_transit_gateway_dx_gateway_attachment) | data source |
| [terraform_remote_state.cicd](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.client_0000](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.direct_connect](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.east_west_firewall](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.mad](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.north_south_firewall](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.shared_test_dmz](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.transit_gateway](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | n/a | `map(any)` | `{}` | no |
| <a name="input_hms_client_id"></a> [hms\_client\_id](#input\_hms\_client\_id) | n/a | `string` | `"0000"` | no |
| <a name="input_hms_deployment"></a> [hms\_deployment](#input\_hms\_deployment) | n/a | `string` | `"fg1"` | no |
| <a name="input_hms_environment_id"></a> [hms\_environment\_id](#input\_hms\_environment\_id) | n/a | `string` | `"n"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"eu-west-2"` | no |

## Outputs

No outputs.
