# -------------------------------
# General Settings
# -------------------------------
infra_array = [
  
   {
    module_name            = "aks"
    name                   = "aks-test"
    cluster_name                   = "aks-test-cluster"
    vnet_name                   = "vnet-test"
    private_subnet_name    = "privatesubnet"
    private_dns_zone_name                   = "testnew.privatelink.dev-rg.azure.net"
    aks_config = {
      control_plane_version                  = "1.32.0"
      system_pool_orchestrator_version       = "1.32.0"
      os_disk_size_gb                        = 30
      system_pool_vm_size                    = "Standard_B2s"
      system_pool_size_count                 = 2
      system_pool_availability_zones         = ["2", "3"]
      user_default_pool_vm_size              = "Standard_B2s"
      user_default_pool_orchestrator_version = "1.31.2"
      user_default_pool_size_count           = 1
      user_default_pool_availability_zones   = ["2", "3"]
      user_spot_pool_vm_size                 = "Standard_D8as_v4"
      user_spot_pool_orchestrator_version    = "1.31.2"
      user_spot_pool_size_min_count          = 2
      user_spot_pool_size_max_count          = 5
      user_spot_pool_availability_zones      = ["2", "3"]
      services_cidr                          = "192.169.0.0/16"
      dns_service_ip                         = "192.169.0.10"
    }
    tags = {
      project       = "test"
      environment           = "dev"
      owner_id        = "testnew"
      provisionedby = "terraform"
    }
  },

  {
    module_name            = "private_dns_zone"
    friendly_name                   = "private_dns_zone_test"
    owner_id               = "testnew"
    vnet_name   = "vnet-test"
    tags = {
      environment = "dev"
      owner_id        = "testnew"
    }
  },

  {
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




