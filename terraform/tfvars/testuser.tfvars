# -------------------------------
# General Settings
# -------------------------------
infra_array = [
  # {
  #   module_name            = "keyvault"
  #   name                   = "dhsagab-sharedkv"
  #   location               = "East US"
  #   publicly_accessible    = true
  #   vnet_name             = "vnet-secure"
  #   private_subnet_name    = "private-subnet" 
  #   private_dns_zone_name  = "dns-zone"
  # },
  
  # {
  #   module_name           = "private_dns_zone"
  #   name                  = "dns-zone"
  #   owner_id              = "testuser"
  #   use_existing_vnet     = true
  #   vnet_name             = "vnet-secure"
    
  # }
  # ,
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




