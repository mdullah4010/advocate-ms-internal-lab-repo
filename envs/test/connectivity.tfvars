location                 = "westus3"
resource_group_name      = "rg-advocate-internal-hub-test-westus3"
hub_virtual_network_name = "vnet-advocate-internal-hub-test-westus3"
hub_address_space        = ["10.0.0.0/16"]

subnets = {
  AzureFirewallSubnet = {
    address_prefixes = ["10.0.0.0/26"]
  }
  GatewaySubnet = {
    address_prefixes = ["10.0.1.0/27"]
  }
  AzureBastionSubnet = {
    address_prefixes = ["10.0.2.0/26"]
  }
  shared-services = {
    address_prefixes = ["10.0.10.0/24"]
  }
}

tags = {
  environment = "test"
  managedBy   = "terraform"
  platform    = "connectivity"
  workload    = "hub"
}