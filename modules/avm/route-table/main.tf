module "this" {
  source  = "Azure/avm-res-network-routetable/azurerm"
  version = "0.5.0"

  bgp_route_propagation_enabled = var.bgp_route_propagation_enabled
  enable_telemetry              = var.enable_telemetry
  location                      = var.location
  lock                          = var.lock
  name                          = var.name
  resource_group_name           = var.resource_group_name
  role_assignments              = var.role_assignments
  routes                        = var.routes
  routes_legacy_mode            = var.routes_legacy_mode
  subnet_resource_ids           = var.subnet_resource_ids
  tags                          = var.tags
}