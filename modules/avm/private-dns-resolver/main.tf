module "this" {
  source  = "Azure/avm-res-network-dnsresolver/azurerm"
  version = "0.8.0"

  location                    = var.location
  name                        = var.name
  resource_group_name         = var.resource_group_name
  virtual_network_resource_id = var.virtual_network_resource_id

  enable_telemetry   = var.enable_telemetry
  inbound_endpoints  = var.inbound_endpoints
  outbound_endpoints = var.outbound_endpoints
  lock               = var.lock
  role_assignments   = var.role_assignments
  tags               = var.tags
}