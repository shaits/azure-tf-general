variable "rbac_requests" {
  type = list(object({
    scope     = string
    role_name = string
  }))
  default = []
}

variable "user_object_id" {
  type = string
}

locals {
  rbac_map = {
    for r in var.rbac_requests :
    "${r.scope}-${r.role_name}" => r
  }
}