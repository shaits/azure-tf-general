
resource "azurerm_role_assignment" "example" {
  for_each             = toset(var.roles)
  scope                = var.resource_id
  role_definition_name = each.value
  principal_id         = var.user_object_id
}
