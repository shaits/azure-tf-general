provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

provider "azuread" {}

data "azurerm_client_config" "current" {}

module "network" {
  source              = "./modules/vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "keyvault" {
  source              = "./modules/keyvault"
  name                = var.keyvault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
}