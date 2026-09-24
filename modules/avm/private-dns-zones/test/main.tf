locals {
  private_dns_zone_name     = "privatelink.blob.core.windows.net"
  resource_group_name       = "rg-private-dns-test-${var.test_run_id}"
  virtual_network_link_name = "link-private-dns-test-${var.test_run_id}"
  virtual_network_name      = "vnet-private-dns-test-${var.test_run_id}"
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

module "private_dns_zone" {
  source = "./.."

  domain_name      = local.private_dns_zone_name
  parent_id        = module.resource_group.id
  enable_telemetry = false
  a_records = {
    test = {
      name         = "test"
      ttl          = 300
      ip_addresses = [cidrhost(var.address_space[0], 4)]
    }
  }
  virtual_network_links = {
    test = {
      name                                   = local.virtual_network_link_name
      virtual_network_id                     = module.virtual_network.id
      registration_enabled                   = false
      private_dns_zone_supports_private_link = true
      resolution_policy                      = var.virtual_network_link_resolution_policy
      tags                                   = var.tags
    }
  }
  tags = var.tags
}