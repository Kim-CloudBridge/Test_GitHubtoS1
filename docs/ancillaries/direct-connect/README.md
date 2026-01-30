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
| <a name="module_globalvars"></a> [globalvars](#module\_globalvars) | ../../tf-global | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_dx_gateway.network](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_gateway) | resource |
| [aws_dx_gateway_association.network](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_gateway_association) | resource |
| [aws_dx_transit_virtual_interface.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_transit_virtual_interface) | resource |
| [aws_dx_transit_virtual_interface.secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_transit_virtual_interface) | resource |
| [aws_ec2_tag.tgw_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_dx_connection.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/dx_connection) | data source |
| [aws_dx_connection.secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/dx_connection) | data source |
| [aws_ec2_transit_gateway_dx_gateway_attachment.network](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_transit_gateway_dx_gateway_attachment) | data source |
| [terraform_remote_state.transit_gateway](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | n/a | `map(any)` | `{}` | no |
| <a name="input_hms_client_id"></a> [hms\_client\_id](#input\_hms\_client\_id) | n/a | `string` | `"0000"` | no |
| <a name="input_hms_deployment"></a> [hms\_deployment](#input\_hms\_deployment) | n/a | `string` | `"direct-connect"` | no |
| <a name="input_hms_environment_id"></a> [hms\_environment\_id](#input\_hms\_environment\_id) | n/a | `string` | `"n"` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | n/a | `map(any)` | `{}` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"eu-west-2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dx_gateway_id"></a> [dx\_gateway\_id](#output\_dx\_gateway\_id) | n/a |
