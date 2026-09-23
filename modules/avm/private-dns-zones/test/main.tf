locals {
  private_dns_zone_name = "privatelink.blob.core.windows.net"
  resource_group_name   = "rg-private-dns-test-${var.test_run_id}"
  virtual_network_name  = "vnet-private-dns-test-${var.test_run_id}"
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
  tags          = var.tags
}

module "private_dns_zones" {
  source = "./.."

  location  = module.resource_group.location
  parent_id = module.resource_group.id
  private_link_private_dns_zones = {
    blob = {
      zone_name = local.private_dns_zone_name
    }
  }
  virtual_network_link_default_virtual_networks = {
    test = {
      virtual_network_resource_id = module.virtual_network.id
    }
  }
  virtual_network_link_resolution_policy_default = var.virtual_network_link_resolution_policy_default
  tags                                           = var.tags
}