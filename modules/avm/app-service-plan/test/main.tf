locals {
  resource_group_name   = "rg-asp-test-${var.test_run_id}"
  app_service_plan_name = "asp-test-${var.test_run_id}"
}

resource "azurerm_resource_group" "this" {
  location = var.location
  name     = local.resource_group_name
  tags     = var.tags
}

module "under_test" {
  source = "./.."

  location                        = azurerm_resource_group.this.location
  name                            = local.app_service_plan_name
  os_type                         = var.os_type
  parent_id                       = azurerm_resource_group.this.id
  async_scaling_enabled           = var.async_scaling_enabled
  managed_identities              = var.managed_identities
  maximum_elastic_worker_count    = var.maximum_elastic_worker_count
  per_site_scaling_enabled        = var.per_site_scaling_enabled
  premium_plan_auto_scale_enabled = var.premium_plan_auto_scale_enabled
  server_farm_resource_type       = var.server_farm_resource_type
  sku_name                        = var.sku_name
  tags                            = var.tags
  virtual_network_subnet_id       = var.virtual_network_subnet_id
  worker_count                    = var.worker_count
  zone_balancing_enabled          = var.zone_balancing_enabled
}
