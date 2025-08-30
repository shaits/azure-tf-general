variable "resource_group_name" {
  default = "dev-rg"
}

variable "location" {
  default = "East US"
}

variable "keyvault_name" {
  default = "dev-keyvault-shayts"
}

variable "storage_name" {
  default = "securestgacct999"
}

variable "tags" {
  description = "The default tags to associate with resources."
  type        = map(string)
  default     = {}
}

variable "aks_config" {
  description = "AKS Configuration"
  type = object({
    cluster_name = string
    dns_prefix   = string
    node_count   = number
    vm_size      = string
  })
  default = {
    cluster_name = "dev-aks-cluster"
    dns_prefix   = "dev-aks"
    node_count   = 2
    vm_size      = "Standard_D2s_v3"
  }
}

variable "app_gtw_config" {
  description = "Application Gateway Configuration"
  default     = {}
}
