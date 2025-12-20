# -------------------------------
# General Settings
# -------------------------------
infra_array = [
  {
    module_name            = "private_dns_zone"
    name                   = "private_dns_zone_test"
    owner_id               = "testnew"
    vnet_name   = "vnet-test"
    tags = {
      environment = "dev"
      owner_id        = "testnew"
    }
  }
  ,{
    module_name            = "vnet"
    name                   = "vnet-test"
    tags = {
      environment = "dev"
      owner_id        = "testuser"
    }
    private_subnet_name = "privatesubnet"
  }
]

# -------------------------------
# RBAC Requests
# -------------------------------
rbac_requests = [
  # {
  #   assignee_type = "user"
  #   assignee_name = "testnew@shaitsabargmail.onmicrosoft.com"
  #   module_name =  "storage"
  #   resource_name = "storagetestshaytsa"
  #   role_name = "Storage Account Contributor"
  # }
]




