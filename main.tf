provider "azurerm" {
  features {}
}

provider "azuread" {}

data "azurerm_client_config" "current" {}

module "network" {
  source              = "./modules/vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
}