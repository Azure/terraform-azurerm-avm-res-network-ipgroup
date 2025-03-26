terraform {
  required_version = "~> 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {}
}


## Section to provide a random Azure region for the resource group
# This allows us to randomize the region for the resource group.
module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "~> 0.1"
}

# This allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}
## End of section to provide a random Azure region for the resource group

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = module.regions.regions[random_integer.region_index.result].name
  name     = module.naming.resource_group.name_unique
}

# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "ip_groups" {
  source = "../../"

  location            = azurerm_resource_group.this.location
  name                = "avm-ip-group"
  resource_group_name = azurerm_resource_group.this.name
  enable_telemetry    = var.enable_telemetry
  ip_addresses        = ["10.0.0.0/24", "10.0.0.10", "192.168.1.1-192.168.1.100", "10.0.0.10-10.0.0.12"]
  tags = {
    env = "test"
  }
  lock = {
    kind = "CanNotDelete"
    name = "lock"
  }
  role_assignments = {
    r1 = {
      role_definition_id_or_name       = "Reader"
      principal_id                     = data.azurerm_client_config.this.object_id
      description                      = "AVM IP Group Reader"
      skip_service_principal_aad_check = false
    }
  }
}

data "azurerm_client_config" "this" {}
