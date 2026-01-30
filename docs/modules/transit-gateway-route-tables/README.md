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
| [aws_ec2_transit_gateway_route_table.transit_gateway_rtb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to this resource | `map(any)` | `{}` | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | Transit Gateway ID if none will be created by this module | `string` | n/a | yes |
| <a name="input_transit_gateway_naming_prefix"></a> [transit\_gateway\_naming\_prefix](#input\_transit\_gateway\_naming\_prefix) | Naming prefix to apply to name tags within this module | `string` | `""` | no |
| <a name="input_transit_gateway_route_tables"></a> [transit\_gateway\_route\_tables](#input\_transit\_gateway\_route\_tables) | List of transit gateway route tables to which will be used as basis for the count and names of resources to be created | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this_transit_gw_rtb"></a> [this\_transit\_gw\_rtb](#output\_this\_transit\_gw\_rtb) | n/a |
