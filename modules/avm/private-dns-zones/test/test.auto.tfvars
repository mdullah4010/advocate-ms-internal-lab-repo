test_run_id   = "local-001"
location      = "westus3"
address_space = ["10.253.0.0/16"]

domain_name = "privatelink.blob.core.windows.net"
parent_id   = null
a_records = {
  test = {
    name         = "test"
    ttl          = 300
    ip_addresses = ["10.253.0.4"]
  }
}
aaaa_records     = {}
cname_records    = {}
enable_telemetry = false
lock             = null
mx_records       = {}
ptr_records      = {}
retry = {
  error_message_regex  = ["ReferencedResourceNotProvisioned", "CannotDeleteResource"]
  interval_seconds     = 10
  max_interval_seconds = 180
  multiplier           = 1.5
  randomization_factor = 0.5
}
role_assignment_name_use_random_uuid = true
role_assignments                     = {}
soa_record                           = null
srv_records                          = {}
tags = {
  environment = "test"
  managedBy   = "terraform"
  purpose     = "private-dns-zones-module-test"
}
timeouts = {
  dns_zones = {
    create = "30m"
    delete = "30m"
    read   = "5m"
    update = "30m"
  }
  vnet_links = {
    create = "30m"
    delete = "30m"
    read   = "5m"
    update = "30m"
  }
}
txt_records = {}
virtual_network_links = {
  test = {
    vnetlinkname                           = null
    name                                   = "link-private-dns-test-local-001"
    vnetid                                 = null
    virtual_network_id                     = null
    autoregistration                       = false
    registration_enabled                   = false
    private_dns_zone_supports_private_link = true
    resolution_policy                      = "Default"
    tags                                   = { purpose = "private-dns-link" }
  }
}