output "vnet_ids" {
  description = "Map of VNet IDs created by the vnet module"
  value       = { for k, m in module.vnet : k => m.vnet_id }
}

output "private_subnet_ids" {
  description = "Map of private subnet IDs from the vnet module"
  value       = { for k, m in module.vnet : k => m.private_subnet_id }
}

output "private_dns_zone_names" {
  description = "Map of DNS zone names created by the private_dns_zone module"
  value       = { for k, m in module.private_dns_zone : k => m.private_dns_zone_name }
}
