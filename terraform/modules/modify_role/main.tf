resource "azurerm_role_assignment" "rbac" {
  for_each             = local.rbac_map
  scope                = each.value.scope
  role_definition_name = each.value.role_name
  principal_id         = var.user_object_id
}
