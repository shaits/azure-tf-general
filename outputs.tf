output "sp_uami_client_id" {
  value = module.sp.uami_client_id
}

output "kube_config" {
  description = "Kubernetes configuration file"
  value       = module.aks.kube_config
  sensitive   = true
}