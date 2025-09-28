variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "tenant_id" {}
variable "publicly_accessible" {
    description = "Whether the Key Vault should be publicly accessible"
    type        = bool
    default     = false
}
variable "private_subnet_id" {}
variable "private_dns_zone_name" {
  description = "The name of the private DNS zone for the storage account"
  type        = string
}
