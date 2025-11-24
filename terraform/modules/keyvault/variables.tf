variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "tenant_id" {}
variable "publicly_accessible" {
    description = "Whether the Key Vault should be publicly accessible"
    type        = bool
    default     = false
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
  description = "The name of the private DNS zone for the Key Vault"
  type        = string
}
