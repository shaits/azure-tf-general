variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "publicly_accessible"  { 
  description = "Whether the storage account should be publicly accessible"
  type        = bool
}

variable "private_subnet_id" {}
variable "private_dns_zone_name" {
  description = "The name of the private DNS zone for the storage account"
  type        = string
}   

variable "storage_roles" {
  description = "List of roles to assign to the Storage Account"
  type        = list(string)
  default     = ["Reader"]
}


