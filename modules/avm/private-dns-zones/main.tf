module "this" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.5.0"

  domain_name = var.domain_name
  parent_id   = var.parent_id

  enable_telemetry                     = var.enable_telemetry
  lock                                 = var.lock
  a_records                            = var.a_records
  aaaa_records                         = var.aaaa_records
  cname_records                        = var.cname_records
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
  virtual_network_links                = var.virtual_network_links
}