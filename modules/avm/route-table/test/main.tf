locals {
  resource_group_name  = "rg-route-table-module-test-${var.test_run_id}"
  virtual_network_name = "vnet-route-table-test-${var.test_run_id}"
  subnet_name          = "snet-route-table-test-${var.test_run_id}"
  route_table_name     = "rt-route-table-test-${var.test_run_id}"
}

module "resource_group" {
  source = "../../resource-group"

  name     = local.resource_group_name
  location = var.location
  tags     = var.tags
}

module "virtual_network" {
  source = "../../virtual-network"

  name          = local.virtual_network_name
  location      = module.resource_group.location
  parent_id     = module.resource_group.id
  address_space = var.address_space
  subnets = {
    route_table = {
      name             = local.subnet_name
      address_prefixes = [var.subnet_address_prefix]
    }
  }
  tags = var.tags
}

module "route_table" {
  source = "./.."

  location                      = module.resource_group.location
  name                          = coalesce(var.name, local.route_table_name)
  resource_group_name           = coalesce(var.resource_group_name, module.resource_group.name)
  bgp_route_propagation_enabled = var.bgp_route_propagation_enabled
  enable_telemetry              = var.enable_telemetry
  lock                          = var.lock
  role_assignments              = var.role_assignments
  routes = merge({
    local = {
      name           = "route-local"
      address_prefix = var.route_address_prefix
      next_hop_type  = "VnetLocal"
    }
  }, var.routes)
  routes_legacy_mode = var.routes_legacy_mode
  subnet_resource_ids = merge({
    route_table = module.virtual_network.subnets["route_table"].resource_id
  }, var.subnet_resource_ids)
  tags = var.tags
}