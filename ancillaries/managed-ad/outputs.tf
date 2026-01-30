output "managed_ad_id" {
  value = aws_directory_service_directory.microsoft_ad.id
}

output "managed_ad_dns_name" {
  value = aws_directory_service_directory.microsoft_ad.name
}

output "managed_ad_ips" {
  value = aws_directory_service_directory.microsoft_ad.dns_ip_addresses
}

output "shared_directory_ids" {
  value = { for accounts, target in aws_directory_service_shared_directory.ad_sharing : accounts => target.shared_directory_id }
}