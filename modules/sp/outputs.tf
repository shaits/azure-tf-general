output "eso_id" {
  description = "ID of the workload identity"
  value       = azurerm_user_assigned_identity.eso.id
}