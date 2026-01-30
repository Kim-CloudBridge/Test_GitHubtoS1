## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_globalvars"></a> [globalvars](#module\_globalvars) | ../../tf-global | n/a |
| <a name="module_kms"></a> [kms](#module\_kms) | ../../modules/kms | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.central_vpc_fl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.allow_delivery_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.sse](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_ssl_requests_only"></a> [allow\_ssl\_requests\_only](#input\_allow\_ssl\_requests\_only) | Additional IAM policy document that can optionally be merged with default created KMS policy | `bool` | `true` | no |
| <a name="input_hms_client_id"></a> [hms\_client\_id](#input\_hms\_client\_id) | n/a | `string` | `"0000"` | no |
| <a name="input_hms_deployment"></a> [hms\_deployment](#input\_hms\_deployment) | n/a | `string` | `"fg1"` | no |
| <a name="input_hms_environment_id"></a> [hms\_environment\_id](#input\_hms\_environment\_id) | n/a | `string` | `"n"` | no |
| <a name="input_hms_product_id"></a> [hms\_product\_id](#input\_hms\_product\_id) | n/a | `string` | `"hms"` | no |
| <a name="input_hms_region_id"></a> [hms\_region\_id](#input\_hms\_region\_id) | n/a | `string` | `"01"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | n/a | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"eu-west-2"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_central_vpc_fl_bucket"></a> [central\_vpc\_fl\_bucket](#output\_central\_vpc\_fl\_bucket) | n/a |
| <a name="output_central_vpc_fl_bucket_arn"></a> [central\_vpc\_fl\_bucket\_arn](#output\_central\_vpc\_fl\_bucket\_arn) | n/a |
