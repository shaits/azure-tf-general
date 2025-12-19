# -------------------------------
# General Settings
# -------------------------------
infra_array = [
  
  ,
  {
    module_name            = "storage"
    name                   = "storagetestshaytsa"
    tags = {
      environment = "dev"
      owner_id        = "testuser"
    }
    publicly_accessible = true
    vnet_name = ""
    private_subnet_name = ""
    private_dns_zone_name = ""
  }
]

# -------------------------------
# RBAC Requests
# -------------------------------
rbac_requests = [
  {
    assignee_type = "user"
    assignee_name = "testnew@shaitsabargmail.onmicrosoft.com"
    module_name =  "storage"
    resource_name = "storagetestshaytsa"
    role_name = "Storage Account Contributor"
  }
]




