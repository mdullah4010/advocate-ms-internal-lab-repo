locals {
  private_endpoint_name        = "pe-storage-test-${var.test_run_id}"
  private_dns_zone_name        = "privatelink.blob.core.windows.net"
  resource_group_name          = "rg-pe-module-test-${var.test_run_id}"
  storage_account_name         = substr("stpe${substr(replace(var.subscription_id, "-", ""), 0, 6)}${replace(lower(var.test_run_id), "-", "")}", 0, 24)
  virtual_network_name         = "vnet-pe-test-${var.test_run_id}"
  private_endpoint_subnet_name = "snet-pe-test-${var.test_run_id}"
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
    private_endpoint = {
      name             = local.private_endpoint_subnet_name
      address_prefixes = [cidrsubnet(var.address_space[0], 8, 0)]
    }
  }
  tags = var.tags
}

# The storage account wrapper module is not currently available in this repository
# or is still under development, so this test uses the resource block directly.
resource "azurerm_storage_account" "test" {
  name                          = local.storage_account_name
  resource_group_name           = module.resource_group.name
  location                      = module.resource_group.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  min_tls_version               = "TLS1_2"
  public_network_access_enabled = false
  tags                          = var.tags
}

# The private DNS zone wrapper module is not currently available in this repository
# or is still under development, so this test uses the resource block directly.
resource "azurerm_private_dns_zone" "blob" {
  name                = local.private_dns_zone_name
  resource_group_name = module.resource_group.name
  tags                = var.tags
}

# The private DNS zone virtual network link wrapper module is not currently available
# in this repository or is still under development, so this test uses the resource block directly.
resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                  = "link-blob-${var.test_run_id}"
  resource_group_name   = module.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = module.virtual_network.id
  tags                  = var.tags
}

module "private_endpoint" {
  source = "./.."

  name                           = local.private_endpoint_name
  network_interface_name         = "nic-${local.private_endpoint_name}"
  location                       = module.resource_group.location
  resource_group_name            = module.resource_group.name
  subnet_resource_id             = module.virtual_network.subnets["private_endpoint"].resource_id
  private_connection_resource_id = azurerm_storage_account.test.id
  subresource_names              = ["blob"]
  private_dns_zone_group_name    = "default"
  private_dns_zone_resource_ids  = [azurerm_private_dns_zone.blob.id]
  tags                           = var.tags
}
