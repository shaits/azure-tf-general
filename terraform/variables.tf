variable "infra_array" {
  description = "List of infra requests. Each object is passed directly to the relevant module."
  type        = any
}

variable "rbac_requests" {
  description = "List of RBAC role assignment requests."
  type = list(object({
    module_name   = string
    assignee_type  = string
    assignee_name  = string
    resource_name = string
    role_name     = string
  }))
  default = []
}

variable "user_object_id" {
  description = "The object ID of the user to assign RBAC roles to."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where resources will be created"
  type        = string
}

variable "location" {
  description = "The location where resources will be created"
  type        = string
}
