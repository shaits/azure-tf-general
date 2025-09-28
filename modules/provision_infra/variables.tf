variable "user_object_id" {
  description = "The object ID of the user to assign roles to."
  type        = string
}

variable "resource_group_name" {
  default = "dev-rg"
}

variable "location" {
  default = "East US"
}


variable "tags" {
  description = "The default tags to associate with resources."
  type        = map(string)
  default     = {}
}


# -------------------------------
# VNET Config
# -------------------------------
variable "create_vnet" {
  description = "Whether to create a VNet"
  type        = bool
  default     = false
}

variable "vnet_roles" {
  description = "Roles to assign to the user for VNet"
  type        = list(string)
  default     = ["Reader"]
}

# -------------------------------
# Key Vault
# -------------------------------
variable "create_kv" {
  description = "Whether to create a Key Vault"
  type        = bool
  default     = false
}

variable "keyvault_name" {
  description = "The name of the Key Vault"
  type        = string
  default     = var.user_id != "" ? "${var.user_id}-keyvault" : "default-keyvault"
}

# -------------------------------
# Storage Config
# -------------------------------
variable "create_storage" {
  description = "Whether to create a Storage Account"
  type        = bool
  default     = false
}
variable "storage_roles" {
  description = "Roles to assign to the user for Storage Account"
  type        = list(string)
  default     = ["Storage Account Contributor", "Reader", "Storage Blob Data Contributor"]
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

