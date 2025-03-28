mock_provider "azurerm" {}
mock_provider "modtm" {}
mock_provider "azapi" {}
mock_provider "random" {}

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
