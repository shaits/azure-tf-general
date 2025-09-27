variable "location" {}
variable "resource_group_name" {}
variable "subnet_id" {}
variable "vm_size" {
    default = "Standard_B1s"
}
variable "username" {
    default = "azureuser"
}
variable "publicly_accessible" {
  description = "Whether the VM should be publicly accessible"
  type        = bool
  default     = false
}
