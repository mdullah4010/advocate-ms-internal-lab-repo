module "this" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.22.2"

  location                = var.location
  parent_id               = var.parent_id
  address_space           = var.address_space
  bgp_community           = var.bgp_community
  ddos_protection_plan    = var.ddos_protection_plan
  diagnostic_settings     = var.diagnostic_settings
  dns_servers             = var.dns_servers
  enable_telemetry        = var.enable_telemetry
  enable_vm_protection    = var.enable_vm_protection
  encryption              = var.encryption
  extended_location       = var.extended_location
  flow_timeout_in_minutes = var.flow_timeout_in_minutes
  ignore_body_changes     = var.ignore_body_changes
  ipam_pools              = var.ipam_pools
  lock                    = var.lock
  name                    = var.name
  peerings                = var.peerings
  retry                   = var.retry
  role_assignments        = var.role_assignments
  subnets                 = var.subnets
  tags                    = var.tags
  timeouts                = var.timeouts
}
