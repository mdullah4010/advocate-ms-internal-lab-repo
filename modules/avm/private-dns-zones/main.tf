module "this" {
  source  = "Azure/avm-ptn-network-private-link-private-dns-zones/azurerm"
  version = "0.23.2"

  location                                                   = var.location
  parent_id                                                  = var.parent_id
  enable_telemetry                                           = var.enable_telemetry
  lock                                                       = var.lock
  private_link_excluded_zones                                = var.private_link_excluded_zones
  private_link_private_dns_zones                             = var.private_link_private_dns_zones
  private_link_private_dns_zones_additional                  = var.private_link_private_dns_zone_additional
  private_link_private_dns_zones_regex_filter                = var.private_link_private_dns_zone_regex_filter
  resource_group_role_assignments                            = var.resource_group_role_assignments
  tags                                                       = var.tags
  timeouts                                                   = var.timeouts
  virtual_network_link_additional_virtual_networks           = var.virtual_network_link_additional_virtual_networks
  virtual_network_link_by_zone_and_virtual_network           = var.virtual_network_link_by_zone_and_virtual_network
  virtual_network_link_default_virtual_networks              = var.virtual_network_link_default_virtual_networks
  virtual_network_link_name_template                         = var.virtual_network_link_name_template
  virtual_network_link_overrides_by_virtual_network          = var.virtual_network_link_overrides_by_virtual_network
  virtual_network_link_overrides_by_zone                     = var.virtual_network_link_overrides_by_zone
  virtual_network_link_overrides_by_zone_and_virtual_network = var.virtual_network_link_overrides_by_zone_and_virtual_network
  virtual_network_link_resolution_policy_default             = var.virtual_network_link_resolution_policy_default
}