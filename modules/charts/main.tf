terraform {
  required_providers {
    helm = { source = "hashicorp/helm", version = "~> 2.13" }   # v2 syntax (set {})
    kubernetes = { source = "hashicorp/kubernetes", version = ">= 2.21" }
  }
}


resource "kubernetes_namespace" "nginx" {
  metadata { name = "ingress-nginx" }
}

resource "helm_release" "nginx" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.8.3"
  namespace  = kubernetes_namespace.nginx.metadata[0].name

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
    value = "/healthz"
  }

  depends_on = [kubernetes_namespace.nginx]
}


# Create ArgoCD namespace
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
  depends_on = [azurerm_kubernetes_cluster.aks]
}

# Install ArgoCD using Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  version    = "5.46.8"

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "server.extraArgs"
    value = "{--insecure}"
  }

  depends_on = [kubernetes_namespace.argocd]
}