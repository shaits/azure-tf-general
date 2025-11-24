resource "azurerm_resource_group" "this" {
  name     = var.group_name
  location = var.location
  tags     = var.tags
}
