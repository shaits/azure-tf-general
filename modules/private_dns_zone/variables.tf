variable owner_id {
  description = "The owner ID for the private DNS zone"
  type        = string
  default     = "testuser"
}
variable resource_group_name {
  description = "The name of the resource group where the private DNS zone will be created"
  type        = string
}

variable virtual_network_id {
  description = "The ID of the virtual network to link with the private DNS zone"
  type        = string
}

locals {
  private_dns_zone_name = "${var.owner_id}.privatelink.${var.resource_group_name}.azure.net"
}



