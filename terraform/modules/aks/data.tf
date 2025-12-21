data "azurerm_client_config" "current" {}

data "azurerm_private_dns_zone" "azmk8s" {
  name = var.private_dns_zone_name
}

data "azurerm_subnet" "cluster" {
  name                 = var.private_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}


data "azuread_group" "admin_group" {
  display_name     = "USINGSYSTEM_ADMIN"
  security_enabled = true
}

data "azurerm_key_vault" "usingsystem" {
  name                = "using-system-vault"
  resource_group_name = var.resource_group_name
}
  
data "azurerm_key_vault_certificate" "usingsystem" {
  name         = "usingsystem"
  key_vault_id = data.azurerm_key_vault.usingsystem.id
}