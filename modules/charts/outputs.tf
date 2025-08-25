
output "argocd_namespace" {
  description = "ArgoCD namespace"
  value       = kubernetes_namespace.argocd.metadata[0].name
}

output "nginx_namespace" {
  description = "Nginx ingress namespace"
  value       = kubernetes_namespace.nginx.metadata[0].name
}