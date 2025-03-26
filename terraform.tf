terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    assert = {
      source  = "hashicorp/assert"
      version = "~> 0.15.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}
