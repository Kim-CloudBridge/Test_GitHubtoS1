output "tier3_db_assume_role_arn" {
  description = "The assume role name for assuming role to this account"
  value       = module.iam.assume_role
}