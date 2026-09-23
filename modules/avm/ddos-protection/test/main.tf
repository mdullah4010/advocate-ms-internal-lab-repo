locals {
  resource_group_name       = "rg-ddos-module-test-${var.test_run_id}"
  ddos_protection_plan_name = "ddos-module-test-${var.test_run_id}"
}

module "resource_group" {
  source = "../../resource-group"

  name     = local.resource_group_name
  location = var.location
  tags     = var.tags
}

module "ddos_protection" {
  source = "./.."

  name                = local.ddos_protection_plan_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  tags                = var.tags
}