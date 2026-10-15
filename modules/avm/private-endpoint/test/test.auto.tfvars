test_run_id   = "local-001"
address_space = ["10.252.0.0/16"]

location                                   = "westus3"
name                                       = "pe-storage-test"
network_interface_name                     = "nic-pe-storage-test"
private_connection_resource_id             = null
resource_group_name                        = null
subnet_resource_id                         = null
application_security_group_association_ids = []
enable_telemetry                           = false
ip_configurations                          = {}
lock                                       = null
private_dns_zone_group_name                = "default"
private_dns_zone_resource_ids              = null
private_service_connection_name            = null
role_assignments                           = {}
subresource_names                          = ["blob"]
tags = {
  environment = "test"
  managedBy   = "terraform"
  purpose     = "private-endpoint-module-test"
}