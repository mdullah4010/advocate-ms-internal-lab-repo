locals {
  resource_group_name  = "rg-vnet-module-test-${var.test_run_id}"
  virtual_network_name = "vnet-module-test-${var.test_run_id}"
}

module "resource_group" {
  source = "../../../resource-group"

  name     = local.resource_group_name
  location = var.location
  tags     = var.tags
}

module "virtual_network" {
  source = "./.."

  name                = local.virtual_network_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = var.tags
}
