# -------------------------------
# General Settings
# -------------------------------
infra_array = [
  {
    module_name            = "vnet"
    location                = "East US"
    resource_group_name    = "dev-rg"
    tags = {
      environment = "dev"
      owner_id        = "testuser"
    }
  },
  {
    module_name           = "private_dns_zone"
    resource_group_name   = "dev-rg"
    owner_id              = "testuser"
    use_existing_vnet     = false   # or true
    existing_vnet_id      = ""      # only used if use_existing_vnet = true
    from_module           = "vnet-0" # only used if use_existing_vnet = false
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




