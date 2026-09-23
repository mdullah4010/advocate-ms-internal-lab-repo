locals {
  network_security_group_name = "nsg-module-test-${var.test_run_id}"
  resource_group_name         = "rg-nsg-module-test-${var.test_run_id}"
}

module "resource_group" {
  source = "../../resource-group"

  name     = local.resource_group_name
  location = var.location
  tags     = var.tags
}

module "network_security_group" {
  source = "./.."

  name                = local.network_security_group_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  security_rules      = var.security_rules
  tags                = var.tags
}