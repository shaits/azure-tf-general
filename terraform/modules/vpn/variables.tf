variable "name" {
  description = "Base name for the VPN gateway resources (used for gateway and public IP)."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Azure region (e.g., eastus)."
  type        = string
}

variable "gateway_subnet_id" {
  description = "The ID of the GatewaySubnet in the VNet."
  type        = string
}

variable "sku" {
  description = "VPN Gateway SKU (e.g., VpnGw1, VpnGw2, VpnGw1AZ, etc.)."
  type        = string
  default     = "VpnGw1"
}

variable "generation" {
  description = "VPN gateway generation (Generation1 or Generation2)."
  type        = string
  default     = "Generation1"
}

variable "vpn_type" {
  description = "VPN type. For P2S, RouteBased is typical."
  type        = string
  default     = "RouteBased"
}

variable "vpn_client_address_pool" {
  description = "Address pool for P2S VPN clients (CIDR). Example: [\"172.16.200.0/24\"]."
  type        = list(string)
}

variable "vpn_client_protocols" {
  description = "Client VPN protocols. Typically OpenVPN. (IKEv2 is optional in some setups)."
  type        = list(string)
  default     = ["OpenVPN"]
}

variable "enable_bgp" {
  description = "Enable BGP on the VPN gateway."
  type        = bool
  default     = false
}

variable "active_active" {
  description = "Enable active-active VPN gateway."
  type        = bool
  default     = false
}

# ----------------------------
# Certificate authentication
# ----------------------------

variable "enable_cert_auth" {
  description = "Enable certificate-based authentication for P2S."
  type        = bool
  default     = true
}

variable "root_certificate_name" {
  description = "Name for the root certificate object in Azure."
  type        = string
  default     = "p2s-root-cert"
}

variable "root_certificate_public_cert_data" {
  type      = string
  sensitive = true
}


# ----------------------------
# Azure AD authentication (optional)
# ----------------------------

variable "enable_aad_auth" {
  description = "Enable Azure AD authentication for P2S (requires OpenVPN)."
  type        = bool
  default     = false
}

variable "aad_tenant" {
  description = "AAD Tenant URL. Example: https://login.microsoftonline.com/<tenant_id>/"
  type        = string
  default     = null
}

variable "aad_audience" {
  description = "AAD audience for VPN. Example commonly used: 41b23e61-6c1e-4545-b367-cd054e0ed4b4 (Azure VPN)."
  type        = string
  default     = null
}

variable "aad_issuer" {
  description = "AAD issuer URL. Example: https://sts.windows.net/<tenant_id>/"
  type        = string
  default     = null
}

# ----------------------------
# Tags
# ----------------------------

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default     = {}
}

# ----------------------------
# Locals
# ----------------------------

locals {
  # P2S auth types accepted by the gateway: "Certificate" and/or "AAD"
  vpn_auth_types = compact([
    var.enable_cert_auth ? "Certificate" : null,
    var.enable_aad_auth  ? "AAD" : null
  ])
}
