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

  name                = coalesce(var.name, local.ddos_protection_plan_name)
  location            = module.resource_group.location
  resource_group_name = coalesce(var.resource_group_name, module.resource_group.name)
  enable_telemetry    = var.enable_telemetry
  lock                = var.lock
  role_assignments    = var.role_assignments
  tags                = var.tags
}