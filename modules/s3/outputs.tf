output "bucket_id" {
  description = "The ID of S3 Bucket"
  value       = aws_s3_bucket.s3_bucket.id
}

output "bucket_arn" {
  description = "The ARN of S3 Bucket"
  value       = aws_s3_bucket.s3_bucket.arn
}

output "bucket_domain_name" {
  description = "The Domain name of S3 Bucket"
  value       = aws_s3_bucket.s3_bucket.bucket_domain_name
}