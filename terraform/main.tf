
terraform {
  backend "azurerm" {}
}

data "azurerm_client_config" "current" {}

module "vnet" {
  for_each = {
    for r in var.infra_array :
    "${r.name}" => r
    if r.module_name == "vnet"
  }
  source                = "./modules/vnet"
  name                  = each.value.name
  location              = var.location
  resource_group_name   = var.resource_group_name
  private_subnet_name   = each.value.private_subnet_name
}

module "private_dns_zone" {
  for_each = {
    for r in var.infra_array :
    "${r.name}" => r
    if r.module_name == "private_dns_zone"
  }
  source                = "./modules/private_dns_zone"
  name                  = each.value.name
  owner_id              = each.value.owner_id
  virtual_network_name  = each.value.vnet_name
  resource_group_name   = var.resource_group_name

  depends_on = [
    module.vnet
  ]
}

module "keyvault" {
  for_each = {
    for r in var.infra_array :
    "${r.name}" => r
    if r.module_name == "keyvault"
  }
  name                  = each.value.name
  source                = "./modules/keyvault"
  location              = var.location
  resource_group_name   = var.resource_group_name
  tenant_id             = data.azurerm_client_config.current.tenant_id
  publicly_accessible   = each.value.publicly_accessible
  vnet_name             = each.value.vnet_name
  private_subnet_name   = each.value.private_subnet_name
  private_dns_zone_name = each.value.private_dns_zone_name
  depends_on = [
    module.vnet,
    module.private_dns_zone
  ]
}

module "storage" {
  for_each = {
    for r in var.infra_array :
    "${r.name}" => r
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

  depends_on = [
    module.vnet,
    module.private_dns_zone
  ]
}

module "uami" {
  for_each = {
    for r in var.infra_array :
    "${r.name}" => r
    if r.module_name == "uami"
  }
  name                  = each.value.name
  source                = "./modules/uami"
  location              = var.location
  resource_group_name   = var.resource_group_name
}

module "aks" {
  for_each = {
    for r in var.infra_array :
    "${r.name}" => r
    if r.module_name == "aks"
  }
  cluster_name          = each.value.cluster_name
  source                = "./modules/aks"
  location              = var.location
  resource_group_name   = var.resource_group_name
  vnet_name             = each.value.vnet_name
  private_subnet_name   = each.value.private_subnet_name
  private_dns_zone_name = each.value.private_dns_zone_name
  aks_config            = each.value.aks_config
}

# RBAC assignments

data "azuread_user" "users" {
  for_each = {
    for r in var.rbac_requests :
    r.assignee_name => r
    if r.assignee_type == "user"
  }
  user_principal_name = each.key
}

data "azuread_service_principal" "sps" {
  for_each = {
    for r in var.rbac_requests :
    r.assignee_name => r
    if r.assignee_type == "service_principal"
  }
  display_name = each.key
}

data "azuread_group" "groups" {
  for_each = {
    for r in var.rbac_requests :
    r.assignee_name => r
    if r.assignee_type == "group"
  }
  display_name = each.key
}

locals {
  resource_ids = merge(
    { for k, v in module.vnet            : k => v.vnet_id },
    { for k, v in module.private_dns_zone: k => v.private_dns_zone_id },
    { for k, v in module.keyvault        : k => v.keyvault_id },
    { for k, v in module.storage         : k => v.storage_account_id }
  )

  assignee_object_ids = merge(
    { for k, v in data.azuread_user.users           : k => v.object_id },
    { for k, v in data.azuread_service_principal.sps: k => v.object_id },
    { for k, v in data.azuread_group.groups         : k => v.object_id }
  )

  rbac_entries = {
    for r in var.rbac_requests :
    "${r.module_name}-${r.resource_name}-${r.role_name}" => {
      resource_name = r.resource_name
      role_name     = r.role_name
      assignee_name = r.assignee_name
    }
  }
}

resource "azurerm_role_assignment" "rbac" {
  for_each = local.rbac_entries

  scope                = try(local.resource_ids[each.value.resource_name], null)
  role_definition_name = each.value.role_name
  principal_id         = local.assignee_object_ids[each.value.assignee_name]

  depends_on = [
    module.vnet,
    module.storage,
    module.keyvault,
    module.private_dns_zone
  ]
}
