module "connectivity_resource_group" {
  source = "../../../modules/resource-group"

  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "hub_virtual_network" {
  source = "../../../modules/virtual-network"

  name                = var.hub_virtual_network_name
  location            = module.connectivity_resource_group.location
  resource_group_name = module.connectivity_resource_group.name
  address_space       = var.hub_address_space
  dns_servers         = var.dns_servers
  tags                = var.tags
}

module "hub_subnet" {
  source = "../../../modules/subnet"

  for_each = var.subnets

  name                                      = each.key
  resource_group_name                       = module.connectivity_resource_group.name
  virtual_network_name                      = module.hub_virtual_network.name
  address_prefixes                          = each.value.address_prefixes
  private_endpoint_network_policies_enabled = each.value.private_endpoint_network_policies_enabled
}
