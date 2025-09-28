output "role_assignment_ids" {
  value = [for ra in azurerm_role_assignment.this : ra.id]
}
