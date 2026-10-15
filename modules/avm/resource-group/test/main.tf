locals {
  resource_group_name = "rg-module-test-${var.test_run_id}"
}

module "resource_group" {
  source = "./.."

  name             = coalesce(var.name, local.resource_group_name)
  location         = var.location
  enable_telemetry = var.enable_telemetry
  lock             = var.lock
  managed_by       = var.managed_by
  retry            = var.retry
  role_assignments = var.role_assignments
  tags             = var.tags
  timeouts         = var.timeouts
}
