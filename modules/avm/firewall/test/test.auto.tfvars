firewall_sku_name   = "AZFW_VNet"
firewall_sku_tier   = "Standard"
location            = "westus3"
name                = "afw-module-test"
resource_group_name = null

diagnostic_settings                  = {}
enable_telemetry                     = false
firewall_ip_configuration            = null
firewall_management_ip_configuration = null
firewall_policy_id                   = null
firewall_private_ip_ranges           = ["IANAPrivateRanges"]
firewall_timeouts                    = null
firewall_virtual_hub                 = null
firewall_zones                       = ["1", "2", "3"]

ip_configurations = {
  primary = {
    name                 = "primary"
    public_ip_address_id = null
    subnet_id            = null
  }
}

lock             = null
role_assignments = {}

tags = {
  environment = "test"
  managedBy   = "terraform"
  purpose     = "azure-firewall-module-test"
}