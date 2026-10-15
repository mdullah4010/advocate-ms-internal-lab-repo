locals {
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

  location                  = var.location
  name                      = var.name
  parent_id                 = coalesce(var.parent_id, module.resource_group.id)
  copy_paste_enabled        = var.copy_paste_enabled
  diagnostic_settings       = var.diagnostic_settings
  enable_telemetry          = var.enable_telemetry
  file_copy_enabled         = var.file_copy_enabled
  ip_connect_enabled        = var.ip_connect_enabled
  kerberos_enabled          = var.kerberos_enabled
  lock                      = var.lock
  private_only_enabled      = var.private_only_enabled
  role_assignments          = var.role_assignments
  scale_units               = var.scale_units
  session_recording_enabled = var.session_recording_enabled
  shareable_link_enabled    = var.shareable_link_enabled
  sku                       = var.sku
  tags                      = var.tags
  tunneling_enabled         = var.tunneling_enabled
  virtual_network_id        = var.virtual_network_id
  zones                     = var.zones
  ip_configuration = merge(var.ip_configuration, {
    subnet_id = module.virtual_network.subnets["bastion"].resource_id
  })
}
