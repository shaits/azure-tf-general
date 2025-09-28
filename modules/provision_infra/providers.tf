terraform {
  required_version = ">= 1.6.0"

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