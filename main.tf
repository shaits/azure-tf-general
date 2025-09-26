data "azurerm_client_config" "current" {}

# module "network" {
#   source              = "./modules/vnet"
#   resource_group_name = var.resource_group_name
#   location            = var.location
# }

module "keyvault" {
  source              = "./modules/keyvault"
  name                = var.keyvault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

module "storage" {
  source              = "./modules/storage"
  name                = var.storage_name
  location            = var.location
  resource_group_name = var.resource_group_name
  private_subnet_id   = module.network.private_subnet_id
}

module "sp" {
  source              = "./modules/sp"
  display_name        = "dev-sp-shayts"
  keyvault_scope      = module.keyvault.keyvault_id
  storage_scope       = module.storage.storage_account_id
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "aks" {
  source              = "./modules/aks"
  cluster_name        = var.aks_config.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.aks_config.dns_prefix
  node_count          = var.aks_config.node_count
  vm_size             = var.aks_config.vm_size
  tags                = var.tags
}


# module "vm" {
#   source              = "./modules/vm"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   subnet_id           = module.network.private_subnet_id
# }