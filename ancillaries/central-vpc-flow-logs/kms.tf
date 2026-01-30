module "kms" {
  source = "../../modules/kms"

  description = "KMS key for central S3 bucket of VPC Flow Logs"

  alias                   = local.key_alias
  deletion_window_in_days = 7

  policy = data.aws_iam_policy_document.kms.json
}