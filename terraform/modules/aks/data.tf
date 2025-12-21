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
  display_name     = "test_group"
  security_enabled = true
}