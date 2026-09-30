module "this" {
  source  = "Azure/avm-res-network-azurefirewall/azurerm"
  version = "0.4.0"

  firewall_sku_name                    = var.firewall_sku_name
  firewall_sku_tier                    = var.firewall_sku_tier
  location                             = var.location
  name                                 = var.name
  resource_group_name                  = var.resource_group_name
  diagnostic_settings                  = var.diagnostic_settings
  enable_telemetry                     = var.enable_telemetry
  firewall_ip_configuration            = var.firewall_ip_configuration
  firewall_management_ip_configuration = var.firewall_management_ip_configuration
  firewall_policy_id                   = var.firewall_policy_id
  firewall_private_ip_ranges           = var.firewall_private_ip_ranges
  firewall_timeouts                    = var.firewall_timeouts
  firewall_virtual_hub                 = var.firewall_virtual_hub
  firewall_zones                       = var.firewall_zones
  ip_configurations                    = var.ip_configurations
  lock                                 = var.lock
  role_assignments                     = var.role_assignments
  tags                                 = var.tags
}