variables {
  resource_group_name = "test-rg"
  location           = "East US"
  keyvault_name      = "test-keyvault-123"
  storage_name       = "teststgacct123"
  tags = {
    Environment = "test"
    Project     = "azure-tf-general"
  }
  aks_config = {
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }
  app_gtw_config = {
    sku = "Standard_v2"
  }
}

run "validate_resource_group" {
  command = plan

  assert {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name cannot be empty"
  }
}

run "validate_location" {
  command = plan

  assert {
    condition     = contains(["East US", "West US", "Central US"], var.location)
    error_message = "Location must be a valid Azure region"
  }
}

run "validate_storage_name" {
  command = plan

  assert {
    condition     = length(var.storage_name) >= 3 && length(var.storage_name) <= 24
    error_message = "Storage account name must be between 3 and 24 characters"
  }

  assert {
    condition     = can(regex("^[a-z0-9]+$", var.storage_name))
    error_message = "Storage account name must contain only lowercase letters and numbers"
  }
}
