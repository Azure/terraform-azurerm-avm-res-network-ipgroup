mock_provider "assert" {}
mock_provider "azapi" {
  mock_data "azapi_client_config" {
    defaults = {
      subscription_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000"
    }
  }
}
mock_provider "azurerm" {
  mock_data "azurerm_subscription" {
    defaults = {
      subscription_id = "00000000-0000-0000-0000-000000000000"
    }
  }
}
mock_provider "terraform" {}

variables {
  ip_addresses        = ["10.0.0.1", "10.0.0.0/24", "10.1.0.1-10.1.0.2"]
  location            = "uksouth"
  name                = "ipg-telemetry-test"
  resource_group_name = "test"
}

run "telemetry_enabled" {
  command = plan

  variables {
    enable_telemetry = true
  }

  assert {
    condition = (
      length(azapi_resource.telemetry) == 1 &&
      length(terraform_data.telemetry) == 1 &&
      length(data.azapi_client_config.telemetry) == 1 &&
      azapi_resource.telemetry[0].type == "Microsoft.Resources/deployments@2025-04-01" &&
      azapi_resource.telemetry[0].location == var.location &&
      azapi_resource.telemetry[0].parent_id == "/subscriptions/00000000-0000-0000-0000-000000000000" &&
      azapi_resource.telemetry[0].body.properties.mode == "Incremental" &&
      length(azapi_resource.telemetry[0].body.properties.template.resources) == 0
    )
    error_message = "Enabled telemetry must create an empty incremental deployment in the requested region and active subscription."
  }

  assert {
    condition = (
      azapi_resource.this.name == var.name &&
      azapi_resource.this.location == var.location &&
      azapi_resource.this.parent_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test" &&
      toset(azapi_resource.this.body.properties.ipAddresses) == var.ip_addresses
    )
    error_message = "Telemetry must preserve the IP Group's name, region, resource group and supported address formats."
  }
}

run "telemetry_disabled" {
  command = plan

  variables {
    enable_telemetry = false
  }

  assert {
    condition = (
      length(azapi_resource.telemetry) == 0 &&
      length(terraform_data.telemetry) == 0 &&
      length(data.azapi_client_config.telemetry) == 0
    )
    error_message = "Disabling telemetry must omit the deployment, instance identifier and client configuration lookup."
  }
}
