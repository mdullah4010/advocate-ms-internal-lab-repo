locals {
  firewall_name        = "afw-module-test-${var.test_run_id}"
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
  name                = "pip-${local.firewall_name}"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = var.tags
}

module "firewall" {
  source = "./.."

  firewall_sku_name = "AZFW_VNet"
  firewall_sku_tier = "Standard"
  firewall_zones    = var.firewall_zones
  ip_configurations = {
    primary = {
      name                 = "primary"
      public_ip_address_id = azurerm_public_ip.firewall.id
      subnet_id            = azurerm_subnet.firewall.id
    }
  }
  location            = module.resource_group.location
  name                = local.firewall_name
  resource_group_name = module.resource_group.name
  tags                = var.tags
}