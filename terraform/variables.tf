variable "infra_array" {
  type    = any
}

variable "rbac_requests" {
  type    = list(any)
  default = []
}       
variable "user_object_id" {
  type    = string
}

variable "resource_group_name" {
  type    = string
}

variable "location" {
  type    = string
}

variable "env" {
  type    = string
}
