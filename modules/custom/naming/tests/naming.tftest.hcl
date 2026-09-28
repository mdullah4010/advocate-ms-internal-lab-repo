run "default_virtual_network_name" {
  command = plan

  variables {
    resource_type      = "virtual_network"
    org_code           = "contoso"
    organization_codes = ["contoso"]
    workload           = "connect"
    workload_codes     = ["connect"]
    region_code        = "eus2"
    environment_code   = "azp"
    instance           = 1
  }

  assert {
    condition     = output.name == "contoso-vnet-connect-eus2-azp-01"
    error_message = "The default pattern did not generate the expected virtual network name."
  }
}

run "extended_resource_group_name" {
  command = plan

  variables {
    resource_type      = "resource_group"
    org_code           = "contoso"
    organization_codes = ["contoso"]
    workload           = "platform"
    workload_codes     = ["platform"]
    purpose            = "connect"
    region_code        = "eus2"
    environment_code   = "azp"
    instance           = 2
  }

  assert {
    condition     = output.name == "contoso-rg-platform-connect-eus2-azp-02"
    error_message = "The resource group pattern did not generate the expected name."
  }
}

run "constrained_storage_account_name" {
  command = plan

  variables {
    resource_type      = "storage_account"
    org_code           = "ah"
    organization_codes = ["ah"]
    workload           = "tfstate"
    workload_codes     = ["tfstate"]
    region_code        = "eus2"
    environment_code   = "azp"
    instance           = 1
  }

  assert {
    condition     = output.name == "ahsttfstateeus2azp01"
    error_message = "The constrained pattern did not generate the expected storage account name."
  }

  assert {
    condition     = output.is_constrained
    error_message = "Storage account names must be marked as constrained."
  }
}

run "management_group_name" {
  command = plan

  variables {
    resource_type      = "management_group"
    org_code           = "contoso"
    organization_codes = ["contoso"]
    workload           = "platform"
    workload_codes     = ["platform"]
    region_code        = "glb"
    environment_code   = "azi"
  }

  assert {
    condition     = output.name == "contoso-platform"
    error_message = "The management group pattern did not generate the expected name."
  }
}

run "constrained_container_registry_name" {
  command = plan

  variables {
    resource_type      = "container_registry"
    org_code           = "ah"
    organization_codes = ["ah"]
    workload           = "platform"
    workload_codes     = ["platform"]
    region_code        = "eus2"
    environment_code   = "azp"
    instance           = 1
  }

  assert {
    condition     = output.name == "ahcrplatformeus2azp01"
    error_message = "The constrained pattern did not generate the expected container registry name."
  }
}

run "reject_unregistered_organization" {
  command = plan

  variables {
    resource_type      = "virtual_network"
    org_code           = "unregistered"
    organization_codes = ["contoso"]
    workload           = "connect"
    workload_codes     = ["connect"]
    region_code        = "eus2"
    environment_code   = "azp"
  }

  expect_failures = [var.org_code]
}

run "require_resource_group_purpose" {
  command = plan

  variables {
    resource_type      = "resource_group"
    org_code           = "contoso"
    organization_codes = ["contoso"]
    workload           = "platform"
    workload_codes     = ["platform"]
    region_code        = "eus2"
    environment_code   = "azp"
  }

  expect_failures = [var.purpose]
}

run "reject_overlength_key_vault_name" {
  command = plan

  variables {
    resource_type      = "key_vault"
    org_code           = "contoso"
    organization_codes = ["contoso"]
    workload           = "platform"
    workload_codes     = ["platform"]
    purpose            = "encryption"
    region_code        = "eus2"
    environment_code   = "azp"
    instance           = 1
  }

  expect_failures = [output.name]
}
