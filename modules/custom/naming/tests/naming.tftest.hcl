run "default_virtual_network_name" {
  command = plan

  variables {
    resource_type      = "virtual_network"
    org_code           = "contoso"
    organization_codes = ["contoso"]
    workload           = "connect"
    workload_codes     = ["connect"]
    region_code        = "eus2"
    environment_code   = "prd"
    instance           = 1
  }

  assert {
    condition     = output.name == "contoso-vnet-connect-eus2-prd-01"
    error_message = "The default pattern did not generate the expected virtual network name."
  }
}

run "resource_group_name" {
  command = plan

  variables {
    resource_type      = "resource_group"
    org_code           = "contoso"
    organization_codes = ["contoso"]
    purpose            = "networking"
    purpose_codes      = ["networking"]
    region_code        = "eus2"
    environment_code   = "azp"
    instance           = 2
  }

  assert {
    condition     = output.name == "contoso-rg-networking-eus2-azp-02"
    error_message = "The resource group pattern did not generate the expected name."
  }
}

run "constrained_storage_account_name" {
  command = plan

  variables {
    resource_type      = "storage_account"
    org_code           = "ah"
    organization_codes = ["ah"]
    purpose            = "tfstate"
    purpose_codes      = ["tfstate"]
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
  }

  assert {
    condition     = output.name == "contoso-mg-platform"
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

run "reject_multiple_function_purpose_tokens" {
  command = plan

  variables {
    resource_type      = "resource_group"
    org_code           = "contoso"
    organization_codes = ["contoso"]
    workload           = "platform"
    workload_codes     = ["platform"]
    purpose            = "connect"
    purpose_codes      = ["connect"]
    region_code        = "eus2"
    environment_code   = "azp"
  }

  expect_failures = [var.purpose]
}

run "purpose_based_public_ip_name" {
  command = plan

  variables {
    resource_type      = "public_ip"
    org_code           = "contoso"
    organization_codes = ["contoso"]
    purpose            = "firewall"
    purpose_codes      = ["firewall"]
    region_code        = "eus2"
    environment_code   = "azp"
    instance           = 1
  }

  assert {
    condition     = output.name == "contoso-pip-firewall-eus2-azp-01"
    error_message = "The public IP pattern must use purpose without a workload token."
  }
}

run "constrained_key_vault_name" {
  command = plan

  variables {
    resource_type      = "key_vault"
    org_code           = "ah"
    organization_codes = ["ah"]
    workload           = "platform"
    workload_codes     = ["platform"]
    region_code        = "eus2"
    environment_code   = "prd"
    instance           = 1
  }

  assert {
    condition     = output.name == "ahkvplatformeus2prd01"
    error_message = "The Key Vault pattern must not contain separators."
  }

  assert {
    condition     = output.is_constrained
    error_message = "Key Vault names must be marked as constrained."
  }
}

run "reject_overlength_key_vault_name" {
  command = plan

  variables {
    resource_type      = "key_vault"
    org_code           = "contoso"
    organization_codes = ["contoso"]
    workload           = "platform"
    workload_codes     = ["platform"]
    region_code        = "eus2"
    environment_code   = "azp"
    instance           = 1
  }

  expect_failures = [output.name]
}
