module "this" {
  source  = "Azure/avm-res-network-bastionhost/azurerm"
  version = "0.9.0"

  location            = var.location
  name                = var.name
  parent_id           = var.parent_id
  copy_paste_enabled  = var.copy_paste_enabled
  diagnostic_settings = var.diagnostic_settings
  enable_telemetry    = var.enable_telemetry
  file_copy_enabled   = var.file_copy_enabled
  ip_configuration    = var.ip_configuration
  ip_connect_enabled  = var.ip_connect_enabled
  kerberos_enabled    = var.kerberos_enabled

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
}