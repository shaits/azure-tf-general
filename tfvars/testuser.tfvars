# -------------------------------
# General Settings
# -------------------------------
user_id = "testuser"
resource_group_name = "dev-rg"
location            = "East US"
tags = {
  environment = "dev"
  owner       = "testuser"
  project     = "shared-infra"
}

# -------------------------------
# VNET Config
# -------------------------------
create_vnet = false
existing_vnet_id = ""
vnet_roles = ["Network Contributor", "Reader"]

# -------------------------------
# Key Vault
# -------------------------------
create_kv = false
existing_kv_name = ""
kv_roles = ["Key Vault Contributor", "Key Vault Secrets User", "Reader"]

# -------------------------------
# Storage Config
# -------------------------------
create_storage = true
existing_storage_name = ""
storage_roles = ["Storage Account Contributor", "Reader", "Storage Blob Data Contributor"]
# -------------------------------
# VM Config
# -------------------------------
create_vm = false
vm_config = {
  vm_name     = "dev-vm-shayts"
  admin_user  = "azureuser"
}
vm_roles = ["Virtual Machine Contributor", "Reader", "Network Contributor"]

# -------------------------------
# AKS Cluster Config
# -------------------------------
create_aks = false
aks_config = {
  cluster_name = "dev-aks-cluster"
  dns_prefix   = "dev-aks"
  node_count   = 2
  vm_size      = "Standard_D2s_v3"
}
aks_roles = ["Azure Kubernetes Service Cluster Admin Role", "Reader", "Network Contributor"]


