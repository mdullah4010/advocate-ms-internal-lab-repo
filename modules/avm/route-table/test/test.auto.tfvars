name                = null
location            = "westus3"
resource_group_name = null

bgp_route_propagation_enabled = true
enable_telemetry              = false
lock                          = null
role_assignments              = {}
routes                        = {}
routes_legacy_mode            = false
subnet_resource_ids           = {}

tags = {
  environment = "test"
  managedBy   = "terraform"
  purpose     = "route-table-module-test"
}