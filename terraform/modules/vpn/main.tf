terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  # P2S auth types accepted by the gateway: "Certificate" and/or "AAD"
  vpn_auth_types = compact([
    var.enable_cert_auth ? "Certificate" : null,
    var.enable_aad_auth  ? "AAD" : null
  ])
}

resource "azurerm_public_ip" "vpn_gw_pip" {
  name                = "${var.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"

  tags = var.tags
}

resource "azurerm_virtual_network_gateway" "vpn_gw" {
  name                = "${var.name}-vpngw"
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = "Vpn"
  vpn_type = var.vpn_type

  active_active = var.active_active
  enable_bgp    = var.enable_bgp
  sku           = var.sku
  generation    = var.generation

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gw_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.gateway_subnet_id
  }

  vpn_client_configuration {
    address_space       = var.vpn_client_address_pool
    vpn_client_protocols = var.vpn_client_protocols
    vpn_auth_types      = local.vpn_auth_types

    dynamic "root_certificate" {
      for_each = var.enable_cert_auth ? [1] : []
      content {
        name             = var.root_certificate_name
        public_cert_data = var.root_certificate_public_cert_data
      }
    }

    dynamic "aad" {
      for_each = var.enable_aad_auth ? [1] : []
      content {
        tenant   = var.aad_tenant
        audience = var.aad_audience
        issuer   = var.aad_issuer
      }
    }
  }

  tags = var.tags

  lifecycle {
    precondition {
      condition     = !var.enable_cert_auth || (var.root_certificate_public_cert_data != null && length(var.root_certificate_public_cert_data) > 0)
      error_message = "enable_cert_auth=true requires root_certificate_public_cert_data to be set."
    }

    precondition {
      condition = !var.enable_aad_auth || (
        contains(var.vpn_client_protocols, "OpenVPN") &&
        var.aad_tenant != null && var.aad_audience != null && var.aad_issuer != null
      )
      error_message = "enable_aad_auth=true requires OpenVPN protocol and aad_tenant/aad_audience/aad_issuer to be set."
    }
  }
}
