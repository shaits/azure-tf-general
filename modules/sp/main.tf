resource "azuread_application" "app" {
  display_name = var.display_name
}

resource "azuread_service_principal" "sp" {
  client_id = azuread_application.app.client_id
}

resource "azuread_service_principal_password" "sp_pass" {
  service_principal_id = azuread_service_principal.sp.id
}

resource "azurerm_role_assignment" "kv_role" {
  scope                = var.keyvault_scope
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = azuread_service_principal.sp.object_id 
}

resource "azurerm_role_assignment" "stg_role" {
  scope                = var.storage_scope
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.sp.object_id 
}
