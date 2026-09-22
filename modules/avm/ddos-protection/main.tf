module "this" {
  source  = "Azure/avm-res-network-ddosprotectionplan/azurerm"
  version = "0.3.0"

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  enable_telemetry    = var.enable_telemetry
  lock                = var.lock
  role_assignments    = var.role_assignments
}