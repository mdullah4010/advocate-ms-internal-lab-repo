locals {
  resource_group_name = "rg-public-ip-module-test-${var.test_run_id}"
  public_ip_name      = "pip-module-test-${var.test_run_id}"
}

module "resource_group" {
  source = "../../resource-group"

  name     = local.resource_group_name
  location = var.location
  tags     = var.tags
}

module "public_ip" {
  source = "./.."

  name                = local.public_ip_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  allocation_method   = var.allocation_method
  sku                 = var.sku
  sku_tier            = var.sku_tier
  tags                = var.tags
}