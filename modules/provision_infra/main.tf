data "azurerm_client_config" "current" {}

data "azurerm_subscription" "primary" {}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

module "network" {
  source              = "./modules/vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "private_dns_zone" {
  source              = "./modules/private_dns_zone"
  resource_group_name = var.resource_group_name
  virtual_network_id  = module.network.vnet_id
}

module "storage" {
  source              = "./modules/storage"
  name                = var.storage_name
  location            = var.location
  resource_group_name = var.resource_group_name
  publicly_accessible = false
  private_subnet_id   = module.network.private_subnet_id
  private_dns_zone_name = module.private_dns_zone.private_dns_zone_name
}

module "vm" {
  source              = "./modules/vm"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = module.network.private_subnet_id
  publicly_accessible = false
}

module "keyvault" {
  source              = "./modules/keyvault"
  name                = var.keyvault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  publicly_accessible = false
  private_subnet_id = module.network.private_subnet_id
  private_dns_zone_name = module.private_dns_zone.private_dns_zone_name
}
