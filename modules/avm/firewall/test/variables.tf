variable "tenant_id" {
  description = "Microsoft Entra tenant ID used for the test deployment."
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID used for the test deployment."
  type        = string
}

variable "location" {
  description = "Azure region for the test resources."
  type        = string
}

variable "test_run_id" {
  description = "Unique identifier appended to temporary resource names."
  type        = string
}

variable "firewall_sku_name" {
  description = "SKU name for the test Azure Firewall."
  type        = string
}

variable "firewall_sku_tier" {
  description = "SKU tier for the test Azure Firewall."
  type        = string
}

variable "name" {
  description = "Name of the test Azure Firewall."
  type        = string
}

variable "resource_group_name" {
  description = "Optional resource group override. When null, the fixture resource group is used."
  type        = string
  default     = null
}

variable "diagnostic_settings" {
  description = "Diagnostic settings for the test Azure Firewall."
  type = map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
}

variable "enable_telemetry" {
  description = "Whether telemetry is enabled for the test Azure Firewall."
  type        = bool
}

variable "firewall_ip_configuration" {
  description = "Deprecated IP configurations for the test Azure Firewall."
  type = list(object({
    name                 = string
    public_ip_address_id = optional(string)
    subnet_id            = optional(string)
  }))
  default = null
}

variable "firewall_management_ip_configuration" {
  description = "Optional management IP configuration for the test Azure Firewall."
  type = object({
    name                 = string
    public_ip_address_id = string
    subnet_id            = string
  })
  default = null
}

variable "firewall_policy_id" {
  description = "Optional Firewall Policy ID for the test Azure Firewall."
  type        = string
  default     = null
}

variable "firewall_private_ip_ranges" {
  description = "Private IP ranges for the test Azure Firewall."
  type        = set(string)
  default     = null
}

variable "firewall_timeouts" {
  description = "Timeouts for the test Azure Firewall."
  type = object({
    create = optional(string)
    delete = optional(string)
    read   = optional(string)
    update = optional(string)
  })
  default = null
}

variable "firewall_virtual_hub" {
  description = "Optional virtual hub configuration for the test Azure Firewall."
  type = object({
    public_ip_count = optional(number)
    virtual_hub_id  = string
  })
  default = null
}

variable "firewall_zones" {
  description = "Availability zones for the test Azure Firewall."
  type        = set(string)
}

variable "ip_configurations" {
  description = "IP configurations for the test Azure Firewall. Null primary IDs use fixture-created resources."
  type = map(object({
    name                 = string
    public_ip_address_id = optional(string)
    subnet_id            = optional(string)
  }))
}

variable "lock" {
  description = "Optional management lock for the test Azure Firewall."
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null
}

variable "role_assignments" {
  description = "Role assignments for the test Azure Firewall."
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
}

variable "tags" {
  description = "Tags applied to the temporary test resources."
  type        = map(string)
}