output "vpn_gateway_id" {
  description = "ID of the VPN gateway."
  value       = azurerm_virtual_network_gateway.vpn_gw.id
}

output "vpn_gateway_name" {
  description = "Name of the VPN gateway."
  value       = azurerm_virtual_network_gateway.vpn_gw.name
}

output "vpn_gateway_public_ip" {
  description = "Public IP address of the VPN gateway."
  value       = azurerm_public_ip.vpn_gw_pip.ip_address
}

output "vpn_gateway_public_ip_id" {
  description = "Public IP resource ID."
  value       = azurerm_public_ip.vpn_gw_pip.id
}

output "vpn_client_configuration" {
  description = "Echo back key P2S settings for debugging."
  value = {
    address_pool  = azurerm_virtual_network_gateway.vpn_gw.vpn_client_configuration[0].address_space
    protocols     = azurerm_virtual_network_gateway.vpn_gw.vpn_client_configuration[0].vpn_client_protocols
    auth_types    = azurerm_virtual_network_gateway.vpn_gw.vpn_client_configuration[0].vpn_auth_types
  }
}
