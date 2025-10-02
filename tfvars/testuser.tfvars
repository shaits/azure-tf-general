# -------------------------------
# General Settings
# -------------------------------
infra_array = [
  {
    module_name            = "keyvault"
    name                   = "dhsagab-sharedkv"
    location               = "East US"
    publicly_accessible    = true
    private_subnet_name    = "private-subnet" 
    private_dns_zone_name  = "dns-zone"
  }
  
  {
    module_name           = "private_dns_zone"
    name                  = "dns-zone"
    owner_id              = "testuser"
    vnet_name             = "vnet-secure"
  }
  ,
  {
    module_name            = "vnet"
    name                   = "vnet-secure"
    tags = {
      environment = "dev"
      owner_id        = "testuser"
    }
    private_subnet_name   = "private-subnet"
  }
]

# -------------------------------
# RBAC Requests
# -------------------------------
rbac_requests = [
  # {
  #   scope     = "/subscriptions/xxxx/resourceGroups/dev-rg/providers/Microsoft.Storage/storageAccounts/team2sa"
  #   role_name = "Storage Blob Data Contributor"
  # },
  # {
  #   scope     = "/subscriptions/xxxx/resourceGroups/dev-rg/providers/Microsoft.KeyVault/vaults/sharedkv"
  #   role_name = "Key Vault Secrets User"
  # }
]

# -------------------------------
user_object_id = "testuser"

resource_group_name = "dev-rg"
location            = "East US"




