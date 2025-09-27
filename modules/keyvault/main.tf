resource "azurerm_key_vault" "kv" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = false
  enable_rbac_authorization   = true
}

resource "azurerm_private_endpoint" "kv_pe" {
  count               = var.publicly_accessible ? 0 : 1
  name                = "kv-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_subnet_id

  private_service_connection {
    name                           = "kv-priv-conn"
    private_connection_resource_id = azurerm_key_vault.kv.id
    is_manual_connection           = false
  }
}

resource "azurerm_private_dns_a_record" "record" {
  count = var.publicly_accessible ? 0 : 1
  name                = azurerm_key_vault.kv.name
  zone_name           = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [
    try(azurerm_private_endpoint.kv_pe.private_service_connection[0].private_ip_address, "")
  ]
}
