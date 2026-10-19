locals {
  resource_group_name = "rg-eh-test-${substr(replace(var.test_run_id, "-", ""), 0, 50)}"
  namespace_name      = "ehns${substr(lower(replace(var.test_run_id, "-", "")), 0, 44)}x"
}

module "resource_group" {
  source = "../../resource-group"

  name     = coalesce(var.resource_group_name, local.resource_group_name)
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "test" {
  name                = "vnet-${local.namespace_name}"
  location            = var.location
  resource_group_name = module.resource_group.name
  address_space       = ["10.252.0.0/16"]
  tags                = var.tags
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "snet-private-endpoints"
  resource_group_name  = module.resource_group.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = ["10.252.0.0/24"]
}

resource "azurerm_private_dns_zone" "event_hub" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = module.resource_group.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "event_hub" {
  name                  = "link-${local.namespace_name}"
  resource_group_name   = module.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.event_hub.name
  virtual_network_id    = azurerm_virtual_network.test.id
  registration_enabled  = false
  tags                  = var.tags
}

module "event_hub" {
  source = "./.."

  auto_inflate_enabled                    = var.auto_inflate_enabled
  capacity                                = var.capacity
  customer_managed_key                    = var.customer_managed_key
  dedicated_cluster_id                    = var.dedicated_cluster_id
  diagnostic_settings                     = var.diagnostic_settings
  enable_telemetry                        = var.enable_telemetry
  event_hubs                              = var.event_hubs
  existing_parent_resource                = var.existing_parent_resource
  ignore_body_changes                     = var.ignore_body_changes
  local_authentication_enabled            = var.local_authentication_enabled
  location                                = var.location
  lock                                    = var.lock
  managed_identities                      = var.managed_identities
  maximum_throughput_units                = var.maximum_throughput_units
  name                                    = coalesce(var.name, local.namespace_name)
  network_rulesets                        = var.network_rulesets
  private_endpoints_manage_dns_zone_group = var.private_endpoints_manage_dns_zone_group
  public_network_access_enabled           = var.public_network_access_enabled
  resource_group_name                     = module.resource_group.name
  resource_types                          = var.resource_types
  retry                                   = var.retry
  role_assignments                        = var.role_assignments
  sku                                     = var.sku
  tags                                    = var.tags
  timeouts                                = var.timeouts

  private_endpoints = merge(var.private_endpoints, {
    test = {
      name                          = "pe-${local.namespace_name}"
      subnet_resource_id            = azurerm_subnet.private_endpoints.id
      private_dns_zone_resource_ids = [azurerm_private_dns_zone.event_hub.id]
      private_dns_zone_group_name   = "default"
      tags                          = var.tags
    }
  })
}
