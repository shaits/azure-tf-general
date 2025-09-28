resource "azurerm_role_assignment" "this" {
  for_each           = toset(var.principals)
  scope              = var.scope
  role_definition_name = var.role_definition_name
  principal_id       = each.value
}
