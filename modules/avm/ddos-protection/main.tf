locals {
  module_version = "avm-ddos-protection-v1.0.0"
  tags = merge(var.tags, {
    module_version = local.module_version
  })
}

module "this" {
  source  = "Azure/avm-res-network-ddosprotectionplan/azurerm"
  version = "0.3.0"

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags
  enable_telemetry    = var.enable_telemetry
  lock                = var.lock
  role_assignments    = var.role_assignments
}