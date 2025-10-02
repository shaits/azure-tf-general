terraform {
  required_version = ">= 1.6.0"
  backend "azurerm" {
    resource_group_name  = "dev-rg"
    storage_account_name = "terfstorageaccount"  # Your storage account name
    container_name       = "tfstate"
    key                  = "terraform.tfstate"  # Path within the container
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.50"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
    
  }
  subscription_id = "2e5317af-6e7a-4222-97cd-3cdeec0f8757"
  tenant_id       = "49f0f4f2-1880-42e8-8951-156da90f5697"
}



provider "azuread" {}

provider "kubernetes" {
  host                   = module.aks.kube_host
  cluster_ca_certificate = base64decode(module.aks.kube_ca)
  client_certificate     = base64decode(module.aks.kube_client_certificate)
  client_key             = base64decode(module.aks.kube_client_key)
}

provider "helm" {
  kubernetes {
    host                   = module.aks.kube_host
    cluster_ca_certificate = base64decode(module.aks.kube_ca)
    client_certificate     = base64decode(module.aks.kube_client_certificate)
    client_key             = base64decode(module.aks.kube_client_key)
  }
}