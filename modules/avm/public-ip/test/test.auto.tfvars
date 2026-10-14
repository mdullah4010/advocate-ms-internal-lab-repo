name                = null
location            = "westus3"
resource_group_name = null

allocation_method       = "Static"
ddos_protection_mode    = "VirtualNetworkInherited"
ddos_protection_plan_id = null
diagnostic_settings     = {}
domain_name_label       = null
edge_zone               = null
enable_telemetry        = false
idle_timeout_in_minutes = 4
ip_tags                 = {}
ip_version              = "IPv4"
lock                    = null
public_ip_prefix_id     = null
reverse_fqdn            = null
role_assignments        = {}
sku                     = "Standard"
sku_tier                = "Regional"

tags = {
  environment = "test"
  managedBy   = "terraform"
  purpose     = "public-ip-module-test"
}

zones = []