data "azurerm_subnet" "subnet" {
  count = var.publicly_accessible ? 0 : 1
  name                = var.private_subnet_name
  resource_group_name = var.resource_group_name
  virtual_network_name = var.vnet_name
}


resource "azurerm_storage_account" "storage" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_private_endpoint" "storage_pe" {
  count = var.publicly_accessible ? 0 : 1
  name                = "storage-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.subnet[0].id

  private_service_connection {
    name                           = "storage-conn"
    private_connection_resource_id = azurerm_storage_account.storage.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}


resource "azurerm_private_dns_a_record" "record" {
  count = var.publicly_accessible ? 0 : 1
  name                = azurerm_storage_account.storage.name
  zone_name           = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [
    try(azurerm_private_endpoint.storage_pe[0].private_service_connection[0].private_ip_address, "")
  ]
}