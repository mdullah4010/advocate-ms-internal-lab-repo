locals {
  resource_abbreviations = {
    action_group                     = "ag"
    application_insights             = "appi"
    application_registration         = "appreg"
    automation_account               = "aa"
    azure_bastion                    = "bas"
    azure_data_factory               = "adf"
    azure_firewall                   = "afw"
    azure_machine_learning_workspace = "mlw"
    azure_openai_service             = "oai"
    backup_vault                     = "bvault"
    container_registry               = "cr"
    data_collection_rule             = "dcr"
    databricks_workspace             = "dbw"
    dns_private_resolver             = "dnspr"
    expressroute_circuit             = "erc"
    firewall_policy                  = "afwp"
    key_vault                        = "kv"
    log_analytics_workspace          = "log"
    managed_devops_pool              = "mdp"
    managed_identity                 = "id"
    management_group                 = "mg"
    network_security_group           = "nsg"
    policy_assignment                = "pa"
    policy_definition                = "pol"
    policy_exemption                 = "pex"
    policy_initiative                = "set"
    private_endpoint                 = "pep"
    public_ip                        = "pip"
    recovery_services_vault          = "rsv"
    resource_group                   = "rg"
    route_table                      = "rt"
    service_principal                = "spn"
    storage_account                  = "st"
    subnet                           = "snet"
    virtual_machine                  = "vm"
    virtual_machine_scale_set        = "vmss"
    virtual_network                  = "vnet"
    virtual_network_gateway          = "vgw"
  }

  resource_constraints = {
    action_group                     = { min = 1, max = 260, pattern = "^[a-z0-9][a-z0-9._-]*[a-z0-9_]$" }
    application_insights             = { min = 1, max = 260, pattern = "^[a-z0-9][a-z0-9._-]*[a-z0-9_]$" }
    application_registration         = { min = 1, max = 120, pattern = "^[a-z0-9][a-z0-9-]*[a-z0-9]$" }
    automation_account               = { min = 6, max = 50, pattern = "^[a-z][a-z0-9-]*[a-z0-9]$" }
    azure_bastion                    = { min = 1, max = 80, pattern = "^[a-z0-9]([a-z0-9._-]*[a-z0-9_])?$" }
    azure_data_factory               = { min = 3, max = 63, pattern = "^[a-z0-9][a-z0-9-]*[a-z0-9]$" }
    azure_firewall                   = { min = 1, max = 80, pattern = "^[a-z0-9]([a-z0-9._-]*[a-z0-9_])?$" }
    azure_machine_learning_workspace = { min = 3, max = 33, pattern = "^[a-z0-9_-]+$" }
    azure_openai_service             = { min = 2, max = 64, pattern = "^[a-z0-9][a-z0-9-]*[a-z0-9]$" }
    backup_vault                     = { min = 2, max = 50, pattern = "^[a-z][a-z0-9-]*$" }
    container_registry               = { min = 5, max = 50, pattern = "^[a-z0-9]+$" }
    data_collection_rule             = { min = 1, max = 64, pattern = "^[a-z0-9]([a-z0-9._-]*[a-z0-9_])?$" }
    databricks_workspace             = { min = 3, max = 64, pattern = "^[a-z0-9_-]+$" }
    dns_private_resolver             = { min = 1, max = 80, pattern = "^[a-z0-9]([a-z0-9_-]*[a-z0-9])?$" }
    expressroute_circuit             = { min = 1, max = 80, pattern = "^[a-z0-9]([a-z0-9._-]*[a-z0-9_])?$" }
    firewall_policy                  = { min = 1, max = 80, pattern = "^[a-z0-9]([a-z0-9._-]*[a-z0-9_])?$" }
    key_vault                        = { min = 3, max = 24, pattern = "^[a-z][a-z0-9-]*[a-z0-9]$" }
    log_analytics_workspace          = { min = 4, max = 63, pattern = "^[a-z0-9][a-z0-9-]*[a-z0-9]$" }
    managed_devops_pool              = { min = 3, max = 44, pattern = "^[a-z0-9][a-z0-9._-]*[a-z0-9]$" }
    managed_identity                 = { min = 3, max = 128, pattern = "^[a-z0-9][a-z0-9_-]*$" }
    management_group                 = { min = 1, max = 90, pattern = "^[a-z0-9][a-z0-9._()-]*[^.]$" }
    network_security_group           = { min = 1, max = 80, pattern = "^[a-z0-9]([a-z0-9._-]*[a-z0-9_])?$" }
    policy_assignment                = { min = 1, max = 64, pattern = "^[a-z0-9_.()-]+$" }
    policy_definition                = { min = 1, max = 64, pattern = "^[a-z0-9_.()-]+$" }
    policy_exemption                 = { min = 1, max = 64, pattern = "^[a-z0-9_.()-]+$" }
    policy_initiative                = { min = 1, max = 64, pattern = "^[a-z0-9_.()-]+$" }
    private_endpoint                 = { min = 2, max = 64, pattern = "^[a-z0-9][a-z0-9._-]*[a-z0-9_]$" }
    public_ip                        = { min = 1, max = 80, pattern = "^[a-z0-9]([a-z0-9._-]*[a-z0-9_])?$" }
    recovery_services_vault          = { min = 2, max = 50, pattern = "^[a-z][a-z0-9-]*$" }
    resource_group                   = { min = 1, max = 90, pattern = "^[a-z0-9_.()-]+[^.]$" }
    route_table                      = { min = 1, max = 80, pattern = "^[a-z0-9]([a-z0-9._-]*[a-z0-9_])?$" }
    service_principal                = { min = 1, max = 120, pattern = "^[a-z0-9][a-z0-9-]*[a-z0-9]$" }
    storage_account                  = { min = 3, max = 24, pattern = "^[a-z0-9]+$" }
    subnet                           = { min = 1, max = 80, pattern = "^[a-z0-9]([a-z0-9._-]*[a-z0-9_])?$" }
    virtual_machine                  = { min = 1, max = 64, pattern = "^[a-z0-9][a-z0-9-]*[a-z0-9]$" }
    virtual_machine_scale_set        = { min = 1, max = 64, pattern = "^[a-z0-9][a-z0-9-]*[a-z0-9]$" }
    virtual_network                  = { min = 2, max = 64, pattern = "^[a-z0-9][a-z0-9._-]*[a-z0-9_]$" }
    virtual_network_gateway          = { min = 1, max = 80, pattern = "^[a-z0-9]([a-z0-9._-]*[a-z0-9_])?$" }
  }

  abbreviation          = local.resource_abbreviations[var.resource_type]
  instance_code         = format("%02d", var.instance)
  standard_tokens       = concat([var.org_code, local.abbreviation, var.workload], var.purpose == null ? [] : [var.purpose], [var.region_code, var.environment_code, local.instance_code], var.uniqueness_suffix == null ? [] : [var.uniqueness_suffix])
  resource_group_tokens = concat([var.org_code, "rg", var.workload], var.purpose == null ? [] : [var.purpose], [var.region_code, var.environment_code, local.instance_code], var.uniqueness_suffix == null ? [] : [var.uniqueness_suffix])

  generated_name = (
    var.resource_type == "management_group" ? join("-", [var.org_code, var.workload]) :
    var.resource_type == "resource_group" ? join("-", local.resource_group_tokens) :
    contains(["container_registry", "storage_account"], var.resource_type) ? join("", local.standard_tokens) :
    join("-", local.standard_tokens)
  )

  constraint = local.resource_constraints[var.resource_type]
}
