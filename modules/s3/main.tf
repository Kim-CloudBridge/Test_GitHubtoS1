resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name

  tags = merge({
    "Name" = var.bucket_name
  }, local.tags)
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]

}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
#   count = var.bucket_policy != "" ? 1 : 0
#   bucket = aws_s3_bucket.s3_bucket.id
#   policy = var.bucket_policy
# }
