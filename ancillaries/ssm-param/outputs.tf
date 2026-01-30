output "ad_service_params_share_arn" {
  value = aws_ssm_parameter.ad_service_account.arn
}

output "ad_service_params_kms_arn" {
  value =  aws_kms_key.ssm_params_kms.arn
}