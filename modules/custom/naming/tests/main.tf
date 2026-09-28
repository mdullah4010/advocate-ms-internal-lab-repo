module "resource_group_name" {
  source = "./.."

  resource_type      = "resource_group"
  org_code           = var.org_code
  organization_codes = var.organization_codes
  workload           = "platform"
  purpose            = "connect"
  purpose_codes      = var.purpose_codes
  region_code        = var.region_code
  environment_code   = var.environment_code
  instance           = var.instance
}

module "virtual_network_name" {
  source = "./.."

  resource_type      = "virtual_network"
  org_code           = var.org_code
  organization_codes = var.organization_codes
  workload           = "connect"
  region_code        = var.region_code
  environment_code   = var.environment_code
  instance           = var.instance
}

module "subnet_name" {
  source = "./.."

  resource_type      = "subnet"
  org_code           = var.org_code
  organization_codes = var.organization_codes
  workload           = "connect"
  purpose            = "firewall"
  purpose_codes      = var.purpose_codes
  region_code        = var.region_code
  environment_code   = var.environment_code
  instance           = var.instance
}

module "public_ip_name" {
  source = "./.."

  resource_type      = "public_ip"
  org_code           = var.org_code
  organization_codes = var.organization_codes
  purpose            = "firewall"
  purpose_codes      = var.purpose_codes
  region_code        = var.region_code
  environment_code   = var.environment_code
  instance           = var.instance
}

module "storage_account_name" {
  source = "./.."

  resource_type      = "storage_account"
  org_code           = var.org_code
  organization_codes = var.organization_codes
  purpose            = "tfstate"
  purpose_codes      = var.purpose_codes
  region_code        = var.region_code
  environment_code   = var.environment_code
  instance           = var.instance
}

module "management_group_name" {
  source = "./.."

  resource_type      = "management_group"
  org_code           = var.org_code
  organization_codes = var.organization_codes
  workload           = "platform"
  region_code        = "glb"
  environment_code   = "azi"
}
