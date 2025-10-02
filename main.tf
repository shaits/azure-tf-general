# main.tf (router)

variable "infra_array" {
  description = "List of infra requests. Each object is passed directly to the relevant module."
  type        = any
}

variable "rbac_requests" {
  description = "List of RBAC role assignment requests."
  type = list(object({
    scope     = string
    role_name = string
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

data "azurerm_client_config" "current" {}

module "vnet" {
  for_each = {
    for r in var.infra_array :
    "${r.module_name}-${r.name}" => r
    if r.module_name == "vnet"
  }
  source              = "./modules/vnet"
  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  private_subnet_name   = each.value.private_subnet_name
}

module "private_dns_zone" {
  for_each = {
    for r in var.infra_array :
    "${r.module_name}-${r.name}" => r
    if r.module_name == "private_dns_zone"
  }
  source              = "./modules/private_dns_zone"
  name                = each.value.name
  owner_id            = each.value.owner_id
  virtual_network_name  = each.value.vnet_name
  resource_group_name = var.resource_group_name
}
module "keyvault" {
  for_each = {
    for r in var.infra_array :
    "${r.module_name}-${r.name}" => r
    if r.module_name == "keyvault"
  }
  name                  = each.value.name
  source                = "./modules/keyvault"
  location              = var.location
  resource_group_name   = var.resource_group_name
  tenant_id             = data.azurerm_client_config.current.tenant_id
  publicly_accessible   = each.value.publicly_accessible
  vnet_name             = each.value.vnet_name
  private_subnet_name    = each.value.private_subnet_name
  private_dns_zone_name = each.value.private_dns_zone_name
}

module "storage" {
  for_each = {
    for r in var.infra_array :
    "${r.module_name}-${r.name}" => r
    if r.module_name == "storage"
  }
  name                  = each.value.name
  source                = "./modules/storage"
  location              = var.location
  resource_group_name   = var.resource_group_name
  publicly_accessible   = each.value.publicly_accessible
  vnet_name             = each.value.vnet_name
  private_subnet_name   = each.value.private_subnet_name
  private_dns_zone_name = each.value.private_dns_zone_name
}

///// RBAC Assignments /////

locals {
  rbac_map = {
    for r in var.rbac_requests :
    "${r.scope}-${r.role_name}" => r
  }
}

resource "azurerm_role_assignment" "rbac" {
  for_each             = local.rbac_map
  scope                = each.value.scope
  role_definition_name = each.value.role_name
  principal_id         = var.user_object_id
}
