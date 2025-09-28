# main.tf (router)
module "vnet" {
  for_each = { for idx, r in var.infra_array : "vnet-${idx}" => r if r.module_name == "vnet" }

  source              = "./modules/vnet"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
}

module "private_dns_zone" {
  for_each = { for idx, r in var.infra_array : "dns-${idx}" => r if r.module_name == "private_dns_zone" }

  source              = "./modules/private_dns_zone"
  resource_group_name = each.value.resource_group_name
  owner_id            = each.value.owner_id

  #  pick existing VNet or one from a module
  virtual_network_id = each.value.use_existing_vnet ? each.value.existing_vnet_id : module.vnet[each.value.from_module].id
}


module "storage" {
  for_each = {
    for idx, r in var.infra_array : "${r.module_name}-${idx}" => r
    if r.module_name == "storage"
  }
  name                  = each.value.name
  source                = "./modules/storage"
  location              = each.value.location
  resource_group_name   = each.value.resource_group_name
  publicly_accessible   = each.value.publicly_accessible
  private_subnet_id     = each.value.private_subnet_id
  private_dns_zone_name = each.value.private_dns_zone_name
}

module "keyvault" {
  for_each = {
    for idx, r in var.infra_array : "${r.module_name}-${idx}" => r
    if r.module_name == "keyvault"
  }
  name                  = each.value.name
  source                = "./modules/keyvault"
  location              = each.value.location
  resource_group_name   = each.value.resource_group_name
  tenant_id             = each.value.tenant_id
  publicly_accessible   = each.value.publicly_accessible
  private_subnet_id     = each.value.private_subnet_id
  private_dns_zone_name = each.value.private_dns_zone_name
}



/////RBAC Assignments/////

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
