resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size
    type       = "VirtualMachineScaleSets"
  }

  identity {
    type = "SystemAssigned"
  }

  # Public cluster for testing
  api_server_access_profile {
    authorized_ip_ranges = ["0.0.0.0/0"]
  }

  network_profile {
    network_plugin = "azure"
    dns_service_ip = "10.2.0.10"
    service_cidr   = "10.2.0.0/24"
  }

  oidc_issuer_enabled = true  

  tags = var.tags
}

resource "azurerm_federated_identity_credential" "eso" {
  name                = "eso-federated-cred"
  resource_group_name = var.resource_group_name
  parent_id           = var.azurerm_user_assigned_identity_eso_id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  subject             = "system:serviceaccount:argocd:eso-akv-sa"
}

