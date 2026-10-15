test_run_id   = "local-001"
address_space = ["10.254.0.0/16"]

location                    = "westus3"
name                        = "dnspr-module-test"
resource_group_name         = null
virtual_network_resource_id = null
enable_telemetry            = false
inbound_endpoints = {
  inbound = {
    name                         = "in-dnspr-module-test"
    subnet_name                  = "fixture-replaces-this-value"
    private_ip_allocation_method = "Dynamic"
    private_ip_address           = null
    tags                         = { endpoint = "inbound" }
    merge_with_module_tags       = true
  }
}
lock = null
outbound_endpoints = {
  outbound = {
    name                   = "out-dnspr-module-test"
    subnet_name            = "fixture-replaces-this-value"
    tags                   = { endpoint = "outbound" }
    merge_with_module_tags = true
    forwarding_ruleset = {
      default = {
        name                                                = "dnsfrs-local-001"
        link_with_outbound_endpoint_virtual_network         = true
        metadata_for_outbound_endpoint_virtual_network_link = null
        tags                                                = { purpose = "forwarding" }
        merge_with_module_tags                              = true
        additional_outbound_endpoint_link                   = null
        additional_virtual_network_links                    = {}
        rules = {
          forwarded = {
            name                     = "rule-forwarded"
            domain_name              = "contoso.com."
            destination_ip_addresses = { "10.10.0.4" = "53" }
            enabled                  = true
            metadata                 = null
          }
        }
      }
    }
  }
}
role_assignments = {}
tags = {
  environment = "test"
  managedBy   = "terraform"
  purpose     = "private-dns-resolver-module-test"
}

resolver_teardown_delay = "300s"