output "storage_account_id" {
  value = azurerm_storage_account.storage.id
}

output "blob_url" {
  value = azurerm_storage_account.storage.primary_blob_endpoint
}
