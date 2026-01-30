output "id" {
  value = aws_kms_key.this.id
}

output "alias_name" {
  value = aws_kms_alias.this.name
}

output "alias_arn" {
  value = aws_kms_alias.this.arn
}

output "key_id" {
  value = aws_kms_key.this.key_id
}

output "arn" {
  value = aws_kms_key.this.arn
}