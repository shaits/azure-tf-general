output "cluster_id" {
  description = "ID of the AKS cluster"
  value       = module.aks.aks_id
}

output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks.aks_name
}

output "kube_host" {
  value = module.aks.kube_config_raw[0].host
}

output "kube_ca" {
  value = module.aks.kube_config_raw[0].cluster_ca_certificate
}

output "kube_client_certificate" {
  value     = module.aks.kube_config_raw[0].client_certificate
  sensitive = true
}

output "kube_client_key" {
  value     = module.aks.kube_config_raw[0].client_key
  sensitive = true
}

output "kube_config" {
  description = "Kubernetes configuration file"
  value       = module.aks.kube_config_raw
  sensitive   = true
}

output "cluster_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = module.aks.cluster_fqdn
}

output "node_resource_group" {
  description = "Auto-generated resource group for AKS nodes"
  value       = module.aks.node_resource_group
}
