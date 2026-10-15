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

  name                    = coalesce(var.name, local.public_ip_name)
  location                = module.resource_group.location
  resource_group_name     = coalesce(var.resource_group_name, module.resource_group.name)
  allocation_method       = var.allocation_method
  ddos_protection_mode    = var.ddos_protection_mode
  ddos_protection_plan_id = var.ddos_protection_plan_id
  diagnostic_settings     = var.diagnostic_settings
  domain_name_label       = var.domain_name_label
  edge_zone               = var.edge_zone
  enable_telemetry        = var.enable_telemetry
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  ip_tags                 = var.ip_tags
  ip_version              = var.ip_version
  lock                    = var.lock
  public_ip_prefix_id     = var.public_ip_prefix_id
  reverse_fqdn            = var.reverse_fqdn
  role_assignments        = var.role_assignments
  sku                     = var.sku
  sku_tier                = var.sku_tier
  tags                    = var.tags
  zones                   = var.zones
}