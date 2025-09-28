# -------------------------------
# General Settings
# -------------------------------
user_id = "shayts"
resource_group_name = "dev-rg"
location            = "East US"
tags = {
  environment = "dev"
  owner       = "shay"
  project     = "shared-infra"
}

# -------------------------------
# Key Vault
# -------------------------------
enable = true
keyvault_name = "dev-keyvault-shayts"

# -------------------------------
# Storage Config
# -------------------------------
storage_name  = "securestgacct999"

# -------------------------------
# VM Config
# -------------------------------
vm_config = {
  vm_name     = "dev-vm-shayts"
  admin_user  = "azureuser"
}

# -------------------------------
# AKS Cluster Config
# -------------------------------
aks_config = {
  cluster_name = "dev-aks-cluster"
  dns_prefix   = "dev-aks"
  node_count   = 2
  vm_size      = "Standard_D2s_v3"
}

# -------------------------------
# Application Gateway Config
# (empty for now, override later if needed)
# -------------------------------
app_gtw_config = {}
