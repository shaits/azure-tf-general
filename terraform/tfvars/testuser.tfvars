# -------------------------------
# General Settings
# -------------------------------
infra_array = [
  {
    module_name            = "uami"
    name                   = "uami-eso"
    tags = {
      environment = "dev"
      owner_id        = "testuser"
    }
  },
  
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
  #   assignee_type = "user"
  #   assignee_name = "testuser@shaitsabargmail.onmicrosoft.com"
  #   module_name =  "storage"
  #   resource_name = "dhsagab-sharedkv"
  #   role_name = "Storage Blob Data Contributor"
  # }
]




