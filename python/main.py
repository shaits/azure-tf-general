import argparse
from pathlib import Path
import hcl2
import os
import shutil


class TerraformGenerator:
    def __init__(self, user_ad_id: str, env: str, tfvars_path: str, tfdir_path:str , location: str = "Indonesia Central"):
        self.user_ad_id = user_ad_id
        self.env = env
        self.location = location
        self.tfvars_path = Path(tfvars_path)
        self.tfdir_path = Path(tfdir_path)
        self.repo_dir = Path(__file__).resolve().parent.parent
        # Parsed tfvars content
        self.data = {}

    # -----------------------------
    # Parse and Validate tfvars
    # -----------------------------
    def load_and_validate_tfvars(self):
        if not self.tfvars_path.exists():
            raise FileNotFoundError(f"tfvars file not found: {self.tfvars_path}")

        with open(self.tfvars_path, "r") as f:
            self.data = hcl2.load(f)

        # Validate infra_array
        infra = self.data.get("infra_array", [])
        rbac = self.data.get("rbac_requests", [])

        if not isinstance(infra, list):
            raise ValueError("infra_array must be a list")
        if not isinstance(rbac, list):
            raise ValueError("rbac_requests must be a list")

        print("✔ tfvars validated successfully")

    def copy_tf_dir_in_repo(self):
        if(os.path.exists(self.tfdir_path)):
            shutil.rmtree(self.tfdir_path)
        shutil.copytree(os.path.join(self.repo_dir,'terraform'),os.path.join(self.tfdir_path))
    # -----------------------------
    # Generate providers.tf
    # -----------------------------
    def generate_providers_tf(self):
        output_path=os.path.join(self.tfdir_path,'providers.tf')
        rg_name = f"{self.env}-rg"
        sa_name = f"{self.env}sta".replace("-","")
        key_name = f"{self.user_ad_id}.tfstate"

        content = f"""
terraform {{
  backend "azurerm" {{
    resource_group_name  = "{rg_name}"
    storage_account_name = "{sa_name}"
    container_name       = "test-cont"
    key                  = "{key_name}"
  }}
}}

provider "azurerm" {{
  features {{
    key_vault {{
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }}
  }}
}}

"""

        Path(output_path).write_text(content.strip() + "\n")
        print(f"✔ providers.tf generated at {output_path}")

    # -----------------------------
    # Generate variables.tf
    # -----------------------------
    def generate_variables_tf(self):
        output_path=os.path.join(self.tfdir_path,'variables.tf')
        content = f"""
variable "infra_array" {{
  type    = list(any)
  default = []
}}

variable "rbac_requests" {{
  type    = list(any)
  default = []
}}       
variable "user_object_id" {{
  type    = string
  default = "{self.user_ad_id}"
}}

variable "resource_group_name" {{
  type    = string
  default = "{self.env}-rg"
}}

variable "location" {{
  type    = string
  default = "{self.location}"
}}

variable "env" {{
  type    = string
  default = "{self.env}"
}}
"""

        Path(output_path).write_text(content.strip() + "\n")
        print(f"✔ variables.tf generated at {output_path}")

    def generate_main_tf(self):
        output_path=os.path.join(self.tfdir_path,'main.tf')
        content = """
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
}

resource "azurerm_role_assignment" "rbac" {
  for_each = {
    for r in var.rbac_requests :
    "${r.module_name}-${r.resource_name}-${r.role_name}" => r
    if try(local.resource_ids["${r.resource_name}"], null) != null
  }

  scope                = local.resource_ids["${each.value.resource_name}"]
  role_definition_name = each.value.role_name
  principal_id         = local.assignee_object_ids["${each.value.assignee_name}"]
}
"""

        Path(output_path).write_text(content.strip() + "\n")
        print(f"✔ main.tf generated at {output_path}")

    def generate_outputs_tf(self):
        output_path=os.path.join(self.tfdir_path,'outputs.tf') 
        content = """
output "vnet_ids" {
  description = "Map of VNet IDs created by the vnet module"
  value       = can(module.vnet) ? { for k, m in module.vnet : k => m.vnet_id } : {}
}

output "private_subnet_ids" {
  description = "Map of private subnet IDs from the vnet module"
  value       = can(module.vnet) ? { for k, m in module.vnet : k => m.private_subnet_id } : {}
}

output "private_dns_zone_names" {
  description = "Map of DNS zone names created by the private_dns_zone module"
  value       = can(module.private_dns_zone) ? { for k, m in module.private_dns_zone : k => m.private_dns_zone_name } : {}
}

output "storage_account_ids" {
  description = "Map of Storage Account IDs created by the storage module"
  value       = can(module.storage) ? { for k, m in module.storage : k => m.storage_account_id } : {}
}

output "blob_urls" {
  description = "Map of Storage Account Blob URLs created by the storage module"
  value       = can(module.storage) ? { for k, m in module.storage : k => m.blob_url } : {}
}

output "keyvault_ids" {
  description = "Map of Key Vault IDs created by the keyvault module"
  value       = can(module.keyvault) ? { for k, m in module.keyvault : k => m.keyvault_id } : {}
}

output "keyvault_uris" {
  description = "Map of Key Vault URIs created by the keyvault module"
  value       = can(module.keyvault) ? { for k, m in module.keyvault : k => m.keyvault_uri } : {}
}

output "kube_configs" {
  description = "Kubeconfig file for the AKS cluster"
  value       = can(module.aks) ? { for k, m in module.aks : k => m.kube_config } : {}
  sensitive   = true
}
"""
        Path(output_path).write_text(content.strip() + "\n")
        print(f"✔ outputs.tf generated at {output_path}")

    # -----------------------------
    # Main execution function
    # -----------------------------
    def run(self):
        self.load_and_validate_tfvars()
        self.copy_tf_dir_in_repo()
        self.generate_providers_tf()
        self.generate_variables_tf()
        self.generate_main_tf()
        self.generate_outputs_tf()
        print("🎉 Terraform files generated successfully!")


# -----------------------------------------
# argparse CLI
# -----------------------------------------
def parse_args():
    parser = argparse.ArgumentParser(description="Dynamic Terraform File Generator")

    parser.add_argument(
        "--user-ad-id",
        required=True,
        help="User Azure AD object ID"
    )

    parser.add_argument(
        "--env",
        required=True,
        help="Environment (e.g., dev, prod)"
    )

    parser.add_argument(
        "--tfvars",
        required=True,
        help="Path to tfvars input file"
    )

    parser.add_argument(
        "--tfdir",
        default=".",
        help="Path to tfdir (default: Current dir)"
    )

    parser.add_argument(
        "--location",
        default="East US",
        help="Azure region (default: East US)"
    )

    return parser.parse_args()

# -----------------------------------------
# Example Usage
# -----------------------------------------
if __name__ == "__main__":
    args = parse_args()
    tg = TerraformGenerator(
        user_ad_id=args.user_ad_id,
        env=args.env,
        tfvars_path=args.tfvars,
        tfdir_path=args.tfdir,
        location=args.location
    )
    tg.run()
