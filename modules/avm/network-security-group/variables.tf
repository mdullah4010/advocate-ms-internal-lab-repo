variable "name" {
  description = "Name of the network security group."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[[:alnum:]]([[:alnum:]_.-]{0,78}?[[:alnum:]_])?$", var.name))
    error_message = "Network security group name must contain 1 to 80 valid characters, start with an alphanumeric character, and end with an alphanumeric character or underscore."
  }
}

variable "location" {
  description = "Azure region for the network security group."
  type        = string
  nullable    = false
}

variable "resource_group_name" {
  description = "Name of the resource group containing the network security group."
  type        = string
  nullable    = false
}

variable "diagnostic_settings" {
  description = "Diagnostic settings to create for the network security group."
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

variable "lock" {
  description = "Resource lock configuration for the network security group."
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null
}

variable "role_assignments" {
  description = "Role assignments to create on the network security group."
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

variable "security_rules" {
  description = "Security rules to create in the network security group."
  type = map(object({
    access                                     = string
    description                                = optional(string)
    destination_address_prefix                 = optional(string)
    destination_address_prefixes               = optional(set(string))
    destination_application_security_group_ids = optional(set(string))
    destination_port_range                     = optional(string)
    destination_port_ranges                    = optional(set(string))
    direction                                  = string
    name                                       = string
    priority                                   = number
    protocol                                   = string
    source_address_prefix                      = optional(string)
    source_address_prefixes                    = optional(set(string))
    source_application_security_group_ids      = optional(set(string))
    source_port_range                          = optional(string)
    source_port_ranges                         = optional(set(string))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      read   = optional(string)
      update = optional(string)
    }))
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to the network security group."
  type        = map(string)
  default     = null
}

variable "timeouts" {
  description = "Timeouts for network security group create, delete, read, and update operations."
  type = object({
    create = optional(string)
    delete = optional(string)
    read   = optional(string)
    update = optional(string)
  })
  default = null
}