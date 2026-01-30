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
| [aws_cloudwatch_log_group.local_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_flow_log.local](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_flow_log.s3_destination](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.local_flow_log_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.logs_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_local_flow_logs_store"></a> [create\_local\_flow\_logs\_store](#input\_create\_local\_flow\_logs\_store) | n/a | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of Flow Logs | `string` | `""` | no |
| <a name="input_s3_destination_arn"></a> [s3\_destination\_arn](#input\_s3\_destination\_arn) | ARN of the S3 Bucket Log Destination | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | `{}` | no |
| <a name="input_traffic_type"></a> [traffic\_type](#input\_traffic\_type) | Traffic Type to Log | `string` | `"ALL"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC for which you want to create a Flow Log | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_local_flow_log_arn"></a> [local\_flow\_log\_arn](#output\_local\_flow\_log\_arn) | n/a |
| <a name="output_local_flow_log_iam_role"></a> [local\_flow\_log\_iam\_role](#output\_local\_flow\_log\_iam\_role) | n/a |
| <a name="output_s3_vpc_flow_log_arn"></a> [s3\_vpc\_flow\_log\_arn](#output\_s3\_vpc\_flow\_log\_arn) | n/a |
