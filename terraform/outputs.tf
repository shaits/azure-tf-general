output "vnet_ids" {
  description = "Map of VNet IDs created by the vnet module"
  value       = can(module.vnet) ? { for k, m in module.vnet : k => m.vnet_id } : {}
}

output "private_subnet_ids" {
  description = "Map of private subnet IDs from the vnet module"
  value       = can(module.vnet) ? { for k, m in module.vnet : k => m.private_subnet_id } : {}
}

output "private_dns_zone_names" {
  description = "Map of DNS zone names created by the private_dns_zone module"
  value       = can(module.private_dns_zone) ? { for k, m in module.private_dns_zone : k => m.private_dns_zone_name } : {}
}

output "storage_account_ids" {
  description = "Map of Storage Account IDs created by the storage module"
  value       = can(module.storage) ? { for k, m in module.storage : k => m.storage_account_id } : {}
}

output "blob_urls" {
  description = "Map of Storage Account Blob URLs created by the storage module"
  value       = can(module.storage) ? { for k, m in module.storage : k => m.blob_url } : {}
}

output "keyvault_ids" {
  description = "Map of Key Vault IDs created by the keyvault module"
  value       = can(module.keyvault) ? { for k, m in module.keyvault : k => m.keyvault_id } : {}
}

output "keyvault_uris" {
  description = "Map of Key Vault URIs created by the keyvault module"
  value       = can(module.keyvault) ? { for k, m in module.keyvault : k => m.keyvault_uri } : {}
}

# output "kube_configs" {
#   description = "Kubeconfig file for the AKS cluster"
#   value       = can(module.aks) ? { for k, m in module.aks : k => m.kube_config } : {}
#   sensitive   = true
# }
