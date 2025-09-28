variable "group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where the resource group should be created"
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Tags to apply to the resource group"
  type        = map(string)
  default     = {}
}
