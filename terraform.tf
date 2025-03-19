terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    # TODO: Ensure all required providers are listed here and the version property includes a constraint on the maximum major version.
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "=0.1.0"
    }
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
    }

  }
}
