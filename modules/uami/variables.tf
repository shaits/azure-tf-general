variable "name" {
  description = "Name of the User Assigned Managed Identity"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the UAMI will be created"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "tags" {
  description = "Tags to assign to the UAMI"
  type        = map(string)
  default     = {}
}
