locals {
  resource_group_name            = "rg-vnet-module-test-${var.test_run_id}"
  secondary_virtual_network_name = "vnet-secondary-test-${var.test_run_id}"

  secondary_subnets = {
    test = {
      name             = "snet-peer-test-${var.test_run_id}"
      address_prefixes = [cidrsubnet(var.peer_address_space[0], 8, 0)]
    }
  }
}

module "resource_group" {
  source = "../../resource-group"

  name     = local.resource_group_name
  location = var.location
  tags     = var.tags
}

module "secondary_virtual_network" {
  source = "./.."

  name          = local.secondary_virtual_network_name
  location      = module.resource_group.location
  parent_id     = module.resource_group.id
  address_space = var.peer_address_space
  dns_servers   = var.dns_servers
  subnets       = local.secondary_subnets
  tags          = var.tags
}

module "virtual_network" {
  source = "./.."

  location                = var.location
  parent_id               = coalesce(var.parent_id, module.resource_group.id)
  address_space           = var.address_space
  bgp_community           = var.bgp_community
  ddos_protection_plan    = var.ddos_protection_plan
  diagnostic_settings     = var.diagnostic_settings
  dns_servers             = var.dns_servers
  enable_telemetry        = var.enable_telemetry
  enable_vm_protection    = var.enable_vm_protection
  encryption              = var.encryption
  extended_location       = var.extended_location
  flow_timeout_in_minutes = var.flow_timeout_in_minutes
  ignore_body_changes     = var.ignore_body_changes
  ipam_pools              = var.ipam_pools
  lock                    = var.lock
  name                    = var.name
  peerings = {
    for key, peering in var.peerings : key => merge(peering, {
      remote_virtual_network_resource_id = coalesce(peering.remote_virtual_network_resource_id, module.secondary_virtual_network.resource_id)
    })
  }
  retry            = var.retry
  role_assignments = var.role_assignments
  subnets          = var.subnets
  tags             = var.tags
  timeouts         = var.timeouts
}
