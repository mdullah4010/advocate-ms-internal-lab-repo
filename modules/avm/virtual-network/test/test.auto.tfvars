test_run_id        = "local-001"
peer_address_space = ["10.251.0.0/16"]

location                = "westus3"
parent_id               = null
address_space           = ["10.250.0.0/16"]
bgp_community           = null
ddos_protection_plan    = null
diagnostic_settings     = {}
dns_servers             = null
enable_telemetry        = false
enable_vm_protection    = false
encryption              = null
extended_location       = null
flow_timeout_in_minutes = null
ignore_body_changes = {
  virtual_networks = []
  virtual_networks_subnets = {
    virtual_networks_subnets = []
  }
  virtual_networks_virtual_network_peerings = {
    virtual_networks_virtual_network_peerings = []
  }
}
ipam_pools = null
lock       = null
name       = "vnet-primary-test"
peerings = {
  secondary = {
    name                                  = "peer-primary-to-secondary-local-001"
    remote_virtual_network_resource_id    = null
    allow_forwarded_traffic               = true
    allow_gateway_transit                 = false
    allow_virtual_network_access          = true
    do_not_verify_remote_gateways         = false
    enable_only_ipv6_peering              = false
    peer_complete_vnets                   = true
    local_peered_address_spaces           = null
    remote_peered_address_spaces          = null
    local_peered_subnets                  = null
    remote_peered_subnets                 = null
    use_remote_gateways                   = false
    create_reverse_peering                = true
    reverse_name                          = "peer-secondary-to-primary-local-001"
    reverse_allow_forwarded_traffic       = true
    reverse_allow_gateway_transit         = false
    reverse_allow_virtual_network_access  = true
    reverse_do_not_verify_remote_gateways = false
    reverse_enable_only_ipv6_peering      = false
    reverse_peer_complete_vnets           = true
    reverse_local_peered_address_spaces   = null
    reverse_remote_peered_address_spaces  = null
    reverse_local_peered_subnets          = null
    reverse_remote_peered_subnets         = null
    reverse_use_remote_gateways           = false
    sync_remote_address_space_enabled     = false
    sync_remote_address_space_triggers    = null
    timeouts = {
      create = "30m"
      read   = "5m"
      update = "30m"
      delete = "30m"
    }
    retry = {
      error_message_regex  = ["ReferencedResourceNotProvisioned"]
      interval_seconds     = 10
      max_interval_seconds = 180
    }
  }
}
retry = {
  error_message_regex  = ["ReferencedResourceNotProvisioned"]
  interval_seconds     = 10
  max_interval_seconds = 180
}
role_assignments = {}
subnets = {
  gateway = {
    name             = "GatewaySubnet"
    address_prefixes = ["10.250.0.0/24"]
  }
  firewall = {
    name             = "AzureFirewallSubnet"
    address_prefixes = ["10.250.1.0/24"]
  }
  bastion = {
    name             = "AzureBastionSubnet"
    address_prefixes = ["10.250.2.0/24"]
  }
  test = {
    name             = "snet-test-local-001"
    address_prefixes = ["10.250.3.0/24"]
  }
}
tags = {
  environment = "test"
  managedBy   = "terraform"
  purpose     = "virtual-network-module-test"
}
timeouts = {
  create = "30m"
  read   = "5m"
  update = "30m"
  delete = "30m"
}