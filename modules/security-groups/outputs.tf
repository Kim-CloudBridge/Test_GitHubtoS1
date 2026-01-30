output "alb_security_group_id" {
  description = "The ID of the ALB Security Group"
  value       = aws_security_group.alb_security_group.id
}

output "nginx_security_group_id" {
  description = "The ID of the nginx Security Group"
  value       = aws_security_group.nginx_security_group.id
}

output "nlb_halo_security_group_id" {
  description = "The ID of the NLB HALO Security Group"
  value       = aws_security_group.nlb_halo_security_group.id
}

output "halo_security_group_id" {
  description = "The ID of HALO Security Group"
  value       = aws_security_group.halo_security_group.id
}

output "nlb_aura_security_group_id" {
  description = "The ID of the NLB AURA Security Group"
  value       = aws_security_group.nlb_aura_security_group.id
}

output "aura_security_group_id" {
  description = "The ID of AURA Security Group"
  value       = aws_security_group.aura_security_group.id
}

output "nlb_core_security_group_id" {
  description = "The ID of the NLB Core Security Group"
  value       = aws_security_group.nlb_core_security_group.id
}

output "core_security_group_id" {
  description = "The ID of LS-CORE Security Group"
  value       = aws_security_group.core_security_group.id
}

output "management_security_group_id" {
  description = "The ID of Management Security Group"
  value       = aws_security_group.management_security_group.id
}

output "mdb_security_group_id" {
  description = "The ID of M-DB Security Group"
  value       = aws_security_group.mdb_security_group.id
}

output "rdb_security_group_id" {
  description = "The ID of R-DB Security Group"
  value       = aws_security_group.rdb_security_group.id
}

output "gen_fsx_security_group_id" {
  description = "The ID of general FSX Security Group rule"
  value       = aws_security_group.fsx_security_group.id
}

output "mdb_fsx_security_group_id" {
  description = "The ID of MDB's FSX Security Group"
  value       = aws_security_group.mdb_fsx_security_group.id
}

output "rdb_fsx_security_group_id" {
  description = "The ID of RDB's FSX Security Group"
  value       = aws_security_group.rdb_fsx_security_group.id
}

output "core_fsx_security_group_id" {
  description = "The ID of Core's FSX Security Group"
  value       = aws_security_group.core_fsx_security_group.id
}

output "appstream_security_group_id" {
  description = "The ID of AppStream Security Group"
  value       = var.enable_appstream ? aws_security_group.appstream_security_group[0].id : ""
}

output "appstream_security_group" {
  description = "Full Security Group for dependency resolution"
  value       = var.enable_appstream ? aws_security_group.appstream_security_group[0] : null
}