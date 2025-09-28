variable "user_object_id" {
    description = "The object ID of the user to assign the roles to"
    type        = string
  
}

variable "resource_id" {
    description = "The ID of the resource to assign the roles to"
    type        = string

}

variable "roles" {
    description = "List of roles to assign to the resource"
    type        = list(string)
}

