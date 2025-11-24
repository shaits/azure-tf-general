resource "azuread_application" "app" {
  display_name = var.display_name
}

resource "azurerm_user_assigned_identity" "eso" {
  name                = "eso-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_role_assignment" "kv_role" {
  scope                = var.keyvault_scope
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = azurerm_user_assigned_identity.eso.principal_id
}

resource "azurerm_role_assignment" "stg_role" {
  scope                = var.storage_scope
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.eso.principal_id
}
