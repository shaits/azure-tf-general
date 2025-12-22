
variable "friendly_name" {
  description = "The name of the private DNS zone"
  type        = string 
}

variable owner_id {
  description = "The owner ID for the private DNS zone"
  type        = string
}
variable resource_group_name {
  description = "The name of the resource group where the private DNS zone will be created"
  type        = string
}

variable virtual_network_name {
  description = "The name of the virtual network to link with the private DNS zone"
  type        = string
}

variable location {
  description = "location"
  type        = string
}

locals {
  private_dns_zone_name = "${var.owner_id}.privatelink.${replace(var.location, " ", "")}.azmk8s.io"
  private_dns_vnet_link_name = "privatelink_${var.friendly_name}_${var.virtual_network_name}"
}



