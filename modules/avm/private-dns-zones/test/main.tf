locals {
  resource_group_name  = "rg-private-dns-test-${var.test_run_id}"
  virtual_network_name = "vnet-private-dns-test-${var.test_run_id}"
}

module "resource_group" {
  source = "../../resource-group"

  name     = local.resource_group_name
  location = var.location
  tags     = var.tags
}

module "virtual_network" {
  source = "../../virtual-network"

  name          = local.virtual_network_name
  location      = module.resource_group.location
  parent_id     = module.resource_group.id
  address_space = var.address_space
  tags          = var.tags
}

module "private_dns_zone" {
  source = "./.."

  domain_name                          = var.domain_name
  parent_id                            = coalesce(var.parent_id, module.resource_group.id)
  a_records                            = var.a_records
  aaaa_records                         = var.aaaa_records
  cname_records                        = var.cname_records
  enable_telemetry                     = var.enable_telemetry
  lock                                 = var.lock
  mx_records                           = var.mx_records
  ptr_records                          = var.ptr_records
  retry                                = var.retry
  role_assignment_name_use_random_uuid = var.role_assignment_name_use_random_uuid
  role_assignments                     = var.role_assignments
  soa_record                           = var.soa_record
  srv_records                          = var.srv_records
  tags                                 = var.tags
  timeouts                             = var.timeouts
  txt_records                          = var.txt_records
  virtual_network_links = {
    for key, link in var.virtual_network_links : key => merge(link, {
      virtual_network_id = coalesce(link.virtual_network_id, link.vnetid, module.virtual_network.id)
    })
  }
}