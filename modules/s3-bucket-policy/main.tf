
resource "aws_s3_bucket_policy" "policy" {

  bucket = var.bucket.bucket_id
  policy = local.policy_type[var.policy_type]
}