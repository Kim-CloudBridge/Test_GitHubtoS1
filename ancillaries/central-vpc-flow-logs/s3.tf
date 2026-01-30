resource "aws_s3_bucket" "central_vpc_fl" {
  bucket = local.bucket_name
  tags   = local.tags
}

resource "aws_s3_bucket_policy" "allow_delivery_service" {
  bucket = aws_s3_bucket.central_vpc_fl.id
  policy = data.aws_iam_policy_document.bucket.json
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.central_vpc_fl.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = local.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}