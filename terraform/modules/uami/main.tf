resource "azurerm_user_assigned_identity" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

output "uami_id" {
  description = "The ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.this.id
}

output "uami_client_id" {
  description = "The client ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.this.client_id
}

output "uami_principal_id" {
  description = "The principal ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.this.principal_id
}
