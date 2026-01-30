output "account_id" {
  description = "The AWS Account ID number of the account that owns or contains the calling entity."
  value       = data.aws_caller_identity.current.account_id
}

output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.tgw_01.id
}

output "transit_gateway_arn" {
  value = aws_ec2_transit_gateway.tgw_01.arn
}