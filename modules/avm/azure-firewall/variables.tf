variable "firewall_sku_name" {
  description = "SKU name of the Firewall. Possible values are AZFW_Hub and AZFW_VNet."
  type        = string
  nullable    = false
}

variable "firewall_sku_tier" {
  description = "SKU tier of the Firewall. Possible values are Premium, Standard, and Basic."
  type        = string
  nullable    = false
}

variable "location" {
  description = "Azure region for the Firewall."
  type        = string
  nullable    = false
}

variable "name" {
  description = "Name of the Firewall."
  type        = string
  nullable    = false
}

variable "resource_group_name" {
  description = "Name of the resource group containing the Firewall."
  type        = string
  nullable    = false
}

variable "diagnostic_settings" {
  description = "Diagnostic settings to create for the Firewall."
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
  default  = {}
  nullable = false
}

variable "enable_telemetry" {
  description = "Controls whether telemetry is enabled for the module."
  type        = bool
  default     = true
  nullable    = false
}

variable "firewall_ip_configuration" {
  description = "Deprecated Firewall IP configuration list. Use ip_configurations instead."
  type = list(object({
    name                 = string
    public_ip_address_id = optional(string)
    subnet_id            = optional(string)
  }))
  default = null
}

variable "firewall_management_ip_configuration" {
  description = "Optional management IP configuration for the Firewall."
  type = object({
    name                 = string
    public_ip_address_id = string
    subnet_id            = string
  })
  default = null
}

variable "firewall_policy_id" {
  description = "Optional ID of the Firewall Policy applied to this Firewall."
  type        = string
  default     = null
}

variable "firewall_private_ip_ranges" {
  description = "Optional SNAT private CIDR ranges or IANAPrivateRanges."
  type        = set(string)
  default     = null
}

variable "firewall_timeouts" {
  description = "Timeouts for Firewall create, delete, read, and update operations."
  type = object({
    create = optional(string)
    delete = optional(string)
    read   = optional(string)
    update = optional(string)
  })
  default = null
}

variable "firewall_virtual_hub" {
  description = "Optional virtual hub configuration for the Firewall."
  type = object({
    public_ip_count = optional(number)
    virtual_hub_id  = string
  })
  default = null
}

variable "firewall_zones" {
  description = "Availability zones for the Azure Firewall."
  type        = set(string)
  default     = ["1", "2", "3"]
}

variable "ip_configurations" {
  description = "IP configurations for the Azure Firewall."
  type = map(object({
    name                 = string
    public_ip_address_id = optional(string)
    subnet_id            = optional(string)
  }))
  default  = {}
  nullable = false
}

variable "lock" {
  description = "Resource lock configuration for the Firewall."
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null
}

variable "role_assignments" {
  description = "Role assignments to create on the Firewall."
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
  default = {}
}

variable "tags" {
  description = "Tags applied to the Firewall."
  type        = map(string)
  default     = null
}