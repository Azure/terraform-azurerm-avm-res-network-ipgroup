terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.71"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~>2.0"
    }
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
    }

  }
}
