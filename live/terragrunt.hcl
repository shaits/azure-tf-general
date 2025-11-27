locals {
  # User selects these using CLI or env vars
  env        = get_env("ENV", "vietnam-dev")
  user_object_id       = get_env("USER_OBJECT_ID", "testuser")
  location             = get_env("LOCATION", "East US")
  tfvars_file = "${get_terragrunt_dir()}/tfvars/${local.env}/${local.user_object_id}.tfvars"
}

terraform {
  source = "../terraform"
  extra_arguments "tfvars" {
    commands  = ["apply", "plan", "destroy"]
    arguments = [
      "-var-file=${local.tfvars_file}"
    ]
  }
}

remote_state {
  backend = "azurerm"
  config = {
    resource_group_name  = "${local.env}-rg"
    storage_account_name = "${replace(local.env, "-", "")}sta"
    container_name       = "test-cont"
    key                  = "${local.user_object_id}.tfstate"
  }
}


generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "azurerm" {
  features {
    key_vault {
        purge_soft_delete_on_destroy    = true
        recover_soft_deleted_key_vaults = true
        }
    }
}
provider "azuread" {}
EOF
}

inputs = {
  env      = local.env
  user_object_id  = local.user_object_id
  resource_group_name = "${local.env}-rg"
  location = local.location

}


