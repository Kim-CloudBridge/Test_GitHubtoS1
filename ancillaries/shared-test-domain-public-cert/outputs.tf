output "testdmzdefault_lendscape_cloud_arn" {
  value = aws_acm_certificate.testdmzdefault_lendscape_cloud.arn
}

output "client_acm_cert_arns" {
  value = [ for k, v in aws_acm_certificate.this: v.arn ]
}