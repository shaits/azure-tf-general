variable "scope" {
  description = "The scope at which to assign the role (resource ID, RG ID, subscription ID)"
  type        = string
}

variable "role_definition_name" {
  description = "Built-in role to assign (Reader, Contributor, Owner, etc.)"
  type        = string
}

variable "principals" {
  description = "List of object IDs (users, groups, service principals) to assign the role to"
  type        = list(string)
}
