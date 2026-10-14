locals {
  resource_group_name  = "rg-afw-module-test-${var.test_run_id}"
  virtual_network_name = "vnet-afw-module-test-${var.test_run_id}"
}

module "resource_group" {
  source = "../../resource-group"

  name     = local.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "this" {
  name                = local.virtual_network_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  address_space       = ["10.251.0.0/16"]
  tags                = var.tags
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.251.0.0/26"]
}

resource "azurerm_public_ip" "firewall" {
  name                = "pip-${var.name}"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = var.tags
}

module "firewall" {
  source = "./.."

  firewall_sku_name                    = var.firewall_sku_name
  firewall_sku_tier                    = var.firewall_sku_tier
  location                             = var.location
  name                                 = var.name
  resource_group_name                  = coalesce(var.resource_group_name, module.resource_group.name)
  diagnostic_settings                  = var.diagnostic_settings
  enable_telemetry                     = var.enable_telemetry
  firewall_ip_configuration            = var.firewall_ip_configuration
  firewall_management_ip_configuration = var.firewall_management_ip_configuration
  firewall_policy_id                   = var.firewall_policy_id
  firewall_private_ip_ranges           = var.firewall_private_ip_ranges
  firewall_timeouts                    = var.firewall_timeouts
  firewall_virtual_hub                 = var.firewall_virtual_hub
  firewall_zones                       = var.firewall_zones
  ip_configurations = merge(var.ip_configurations, {
    primary = merge(var.ip_configurations.primary, {
      public_ip_address_id = coalesce(var.ip_configurations.primary.public_ip_address_id, azurerm_public_ip.firewall.id)
      subnet_id            = coalesce(var.ip_configurations.primary.subnet_id, azurerm_subnet.firewall.id)
    })
  })
  lock             = var.lock
  role_assignments = var.role_assignments
  tags             = var.tags
}