variables {
  resource_group_name = "test-rg-integration"
  location           = "East US"
  keyvault_name      = "test-kv-integration"
  storage_name       = "teststgint999"
  tags = {
    Environment = "test"
    TestType    = "integration"
  }
  aks_config = {
    node_count = 1
    vm_size    = "Standard_B2s"
  }
  app_gtw_config = {
    sku = "Standard_v2"
  }
}

run "deploy_and_validate" {
  command = apply

  assert {
    condition     = module.network.vnet_id != null
    error_message = "VNet should be created"
  }

  assert {
    condition     = module.keyvault.keyvault_id != null
    error_message = "Key Vault should be created"
  }

  assert {
    condition     = module.storage.storage_account_id != null
    error_message = "Storage account should be created"
  }
}


