locals {
  resource_group_name            = "rg-vnet-module-test-${var.test_run_id}"
  primary_virtual_network_name   = "vnet-primary-test-${var.test_run_id}"
  secondary_virtual_network_name = "vnet-secondary-test-${var.test_run_id}"

  primary_subnets = {
    gateway = {
      name             = "GatewaySubnet"
      address_prefixes = [cidrsubnet(var.address_space[0], 8, 0)]
    }
    firewall = {
      name             = "AzureFirewallSubnet"
      address_prefixes = [cidrsubnet(var.address_space[0], 8, 1)]
    }
    bastion = {
      name             = "AzureBastionSubnet"
      address_prefixes = [cidrsubnet(var.address_space[0], 8, 2)]
    }
    test = {
      name             = "snet-test-${var.test_run_id}"
      address_prefixes = [cidrsubnet(var.address_space[0], 8, 3)]
    }
  }

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
  dns_servers = length(var.dns_servers) > 0 ? {
    dns_servers = var.dns_servers
  } : null
  subnets = local.secondary_subnets
  tags    = var.tags
}

module "virtual_network" {
  source = "./.."

  name          = local.primary_virtual_network_name
  location      = module.resource_group.location
  parent_id     = module.resource_group.id
  address_space = var.address_space
  dns_servers = length(var.dns_servers) > 0 ? {
    dns_servers = var.dns_servers
  } : null
  peerings = {
    secondary = {
      name                                 = "peer-primary-to-secondary-${var.test_run_id}"
      remote_virtual_network_resource_id   = module.secondary_virtual_network.resource_id
      allow_forwarded_traffic              = true
      allow_virtual_network_access         = true
      create_reverse_peering               = true
      reverse_name                         = "peer-secondary-to-primary-${var.test_run_id}"
      reverse_allow_forwarded_traffic      = true
      reverse_allow_virtual_network_access = true
    }
  }
  subnets = local.primary_subnets
  tags    = var.tags
}
