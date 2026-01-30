output "central_vpc_fl_bucket" {
  value = aws_s3_bucket.central_vpc_fl.bucket
}

output "central_vpc_fl_bucket_arn" {
  value = aws_s3_bucket.central_vpc_fl.arn
}