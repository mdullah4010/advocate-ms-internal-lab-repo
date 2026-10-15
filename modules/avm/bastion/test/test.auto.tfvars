location      = "westus3"
address_space = ["10.251.0.0/16"]

name                 = "bas-module-test"
parent_id            = null
copy_paste_enabled   = true
diagnostic_settings  = {}
enable_telemetry     = false
file_copy_enabled    = false
ip_connect_enabled   = false
kerberos_enabled     = false
lock                 = null
private_only_enabled = false
role_assignments     = {}
scale_units          = 2

ip_configuration = {
  name                             = "ipconfig-bas-module-test"
  subnet_id                        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example/providers/Microsoft.Network/virtualNetworks/vnet-example/subnets/AzureBastionSubnet"
  create_public_ip                 = true
  public_ip_tags                   = { purpose = "azure-bastion-module-test" }
  public_ip_merge_with_module_tags = true
  public_ip_address_name           = "pip-bas-module-test"
  public_ip_address_id             = null
}

session_recording_enabled = false
shareable_link_enabled    = false
sku                       = "Basic"
tunneling_enabled         = false
virtual_network_id        = null
zones                     = []

tags = {
  environment = "test"
  managedBy   = "terraform"
  purpose     = "azure-bastion-module-test"
}