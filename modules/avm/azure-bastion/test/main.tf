locals {
  bastion_name         = "bas-module-test-${var.test_run_id}"
  resource_group_name  = "rg-bas-module-test-${var.test_run_id}"
  virtual_network_name = "vnet-bas-test-${var.test_run_id}"
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
    # Azure requires this exact subnet name, sized /26 or larger.
    bastion = {
      name             = "AzureBastionSubnet"
      address_prefixes = [cidrsubnet(var.address_space[0], 10, 0)]
    }
  }
  tags = var.tags
}

module "azure_bastion" {
  source = "./.."

  name             = local.bastion_name
  location         = module.resource_group.location
  parent_id        = module.resource_group.id
  enable_telemetry = false
  sku              = var.sku
  zones            = var.zones
  ip_configuration = {
    name                   = "ipconfig-${local.bastion_name}"
    subnet_id              = module.virtual_network.subnets["bastion"].resource_id
    create_public_ip       = true
    public_ip_address_name = "pip-${local.bastion_name}"
  }
  tags = var.tags
}
