module "this" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "0.2.1"

  allocation_method                  = var.allocation_method
  ddos_protection_mode               = var.ddos_protection_mode
  ddos_protection_plan_id            = var.ddos_protection_plan_id
  diagnostic_settings                = var.diagnostic_settings
  domain_name_label                  = var.domain_name_label
  edge_zone                          = var.edge_zone
  enable_telemetry                   = var.enable_telemetry
  idle_timeout_in_minutes            = var.idle_timeout_in_minutes
  ip_tags                            = var.ip_tags
  ip_version                         = var.ip_version
  lock                               = var.lock
  location                           = var.location
  name                               = var.name
  public_ip_prefix_id                = var.public_ip_prefix_id
  reverse_fqdn                       = var.reverse_fqdn
  role_assignments                   = var.role_assignments
  sku                                = var.sku
  sku_tier                           = var.sku_tier
  tags                               = var.tags
  zones                              = var.zones
  resource_group_name                = var.resource_group_name
}