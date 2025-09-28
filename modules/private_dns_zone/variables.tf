variable private_dns_zone_name {
  description = "The name of the private DNS zone"
  type        = string
  default     = "privatelink.dev.azure.net"
}

variable resource_group_name {
  description = "The name of the resource group where the private DNS zone will be created"
  type        = string
}

variable virtual_network_id {
  description = "The ID of the virtual network to link with the private DNS zone"
  type        = string
}




