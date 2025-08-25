variables {
  resource_group_name = "test-rg-aks"
  location           = "East US"
  keyvault_name      = "test-kv-aks"
  storage_name       = "teststgaks999"
  tags = {
    Environment = "test"
    Component   = "aks"
  }
  aks_config = {
    cluster_name = "test-aks-cluster"
    dns_prefix   = "test-aks"
    node_count   = 1
    vm_size      = "Standard_B2s"
  }
  app_gtw_config = {}
}

run "validate_aks_config" {
  command = plan

  assert {
    condition     = var.aks_config.cluster_name != ""
    error_message = "AKS cluster name cannot be empty"
  }

  assert {
    condition     = var.aks_config.node_count > 0
    error_message = "AKS node count must be greater than 0"
  }

  assert {
    condition     = contains(["Standard_B2s", "Standard_DS2_v2", "Standard_D2s_v3"], var.aks_config.vm_size)
    error_message = "AKS VM size must be a supported size"
  }
}

run "test_aks_deployment" {
  command = plan

  assert {
    condition     = module.aks.cluster_name == var.aks_config.cluster_name
    error_message = "AKS cluster name should match input variable"
  }

  assert {
    condition     = module.aks.argocd_namespace == "argocd"
    error_message = "ArgoCD should be deployed in argocd namespace"
  }

  assert {
    condition     = module.aks.nginx_namespace == "nginx-ingress"
    error_message = "Nginx ingress should be deployed in nginx-ingress namespace"
  }
}
