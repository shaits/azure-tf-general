variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "publicly_accessible"  { 
  description = "Whether the storage account should be publicly accessible"
  type        = bool
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "private_subnet_name" {
  description = "The name of the subnet to deploy the private endpoint into"
  type        = string
}
variable "private_dns_zone_name" {
  description = "The name of the private DNS zone for the storage account"
  type        = string
}   



