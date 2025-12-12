data "azurerm_client_config" "current" {}

data "azurerm_private_dns_zone" "azmk8s" {
  name = "privatelink.${var.location}.azmk8s.io"
}

data "azurerm_subnet" "cluster" {
  name                 = "ClusterSubnet"
  virtual_network_name = "usingsystem-vnet"
  resource_group_name  = "usingsystem-vnet-rg"
}


data "azuread_group" "admin_group" {
  display_name     = "USINGSYSTEM_ADMIN"
  security_enabled = true
}

data "azurerm_key_vault" "usingsystem" {
  name                = "using-system-vault"
  resource_group_name = "using-system-vault-rg"
}
  
data "azurerm_key_vault_certificate" "usingsystem" {
  name         = "usingsystem"
  key_vault_id = data.azurerm_key_vault.usingsystem.id
}