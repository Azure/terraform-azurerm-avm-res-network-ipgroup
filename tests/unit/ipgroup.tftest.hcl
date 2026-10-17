mock_provider "assert" {}
mock_provider "azurerm" {
  mock_data "azurerm_subscription" {
    defaults = {
      subscription_id = "00000000-0000-0000-0000-000000000000"
    }
  }
}
mock_provider "azapi" {
  mock_data "azapi_client_config" {
    defaults = {
      subscription_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000"
    }
  }
}
mock_provider "terraform" {}

variables {
  enable_telemetry    = false
  resource_group_name = "test"
  name                = "test"
  ip_addresses        = ["10.0.0.0/16"]
  location            = "uksouth"
}

run "name_validation" {
  command = plan

  variables {
    name = "ip#123"
  }

  expect_failures = [var.name]
}

run "ip_address_validation" {
  command = plan

  variables {
    ip_addresses = ["456.127.89.0"]
  }

  expect_failures = [var.ip_addresses]
}

run "ip_address_cidr_validation" {
  command = plan

  variables {
    ip_addresses = ["10.0.0.0/56"]
  }

  expect_failures = [var.ip_addresses]
}

run "ip_address_range_validation" {
  command = plan

  variables {
    ip_addresses = ["10.0.0.0=10.0.0.23"]
  }

  expect_failures = [var.ip_addresses]
}
