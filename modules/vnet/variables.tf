variable "name" {
  description = "The name of the resource"
  type        = string
  
}
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}
variable "location" {
  description = "The location of the resource"
  type        = string
}

variable "private_subnet_name" {
  description = "The name of the private subnet"
  type        = string
}