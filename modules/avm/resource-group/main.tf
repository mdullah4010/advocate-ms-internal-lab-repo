module "this" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.4.0"

  name             = var.name
  location         = var.location
  enable_telemetry = var.enable_telemetry
  lock             = var.lock
  managed_by       = var.managed_by
  retry            = var.retry
  role_assignments = var.role_assignments
  tags             = var.tags
  timeouts         = var.timeouts
}
