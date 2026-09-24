variable "allocation_method" {
  description = "Allocation method for the public IP address."
  type        = string
  default     = "Static"

  validation {
    condition     = contains(["Dynamic", "Static"], var.allocation_method)
    error_message = "allocation_method must be Dynamic or Static."
  }
}

variable "ddos_protection_mode" {
  description = "DDoS protection mode for the public IP address."
  type        = string
  default     = "VirtualNetworkInherited"

  validation {
    condition     = var.ddos_protection_mode == null || contains(["Enabled", "Disabled", "VirtualNetworkInherited"], var.ddos_protection_mode)
    error_message = "ddos_protection_mode must be Enabled, Disabled, or null."
  }
}

variable "ddos_protection_plan_id" {
  description = "Resource ID of the DDoS protection plan associated with the public IP address."
  type        = string
  default     = null

  validation {
    condition     = var.ddos_protection_plan_id == null || can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.Network/ddosProtectionPlans/[^/]+$", var.ddos_protection_plan_id))
    error_message = "ddos_protection_plan_id must be a valid DDoS protection plan resource ID or null."
  }
}

variable "diagnostic_settings" {
  description = "Diagnostic settings to create for the public IP address."
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

variable "domain_name_label" {
  description = "DNS label for the public IP address."
  type        = string
  default     = null

  validation {
    condition     = var.domain_name_label == null || can(regex("^[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?$", var.domain_name_label))
    error_message = "domain_name_label must contain only lowercase letters, numbers, and hyphens, and must not start or end with a hyphen."
  }
}

variable "edge_zone" {
  description = "Azure Edge Zone in which to deploy the public IP address."
  type        = string
  default     = null
}

variable "enable_telemetry" {
  description = "Controls whether telemetry is enabled for the AVM module."
  type        = bool
  default     = true
  nullable    = false
}

variable "idle_timeout_in_minutes" {
  description = "TCP idle timeout in minutes for the public IP address."
  type        = number
  default     = 4

  validation {
    condition     = var.idle_timeout_in_minutes >= 4 && var.idle_timeout_in_minutes <= 30
    error_message = "idle_timeout_in_minutes must be between 4 and 30."
  }
}

variable "ip_tags" {
  description = "IP tags to apply to the public IP address."
  type        = map(string)
  default     = {}
}

variable "ip_version" {
  description = "IP version for the public IP address."
  type        = string
  default     = "IPv4"

  validation {
    condition     = contains(["IPv4", "IPv6"], var.ip_version)
    error_message = "ip_version must be IPv4 or IPv6."
  }
}

variable "location" {
  description = "Azure region where the public IP address will be created."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "location must not be empty."
  }
}

variable "lock" {
  description = "Resource lock configuration for the public IP address."
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null

  validation {
    condition     = var.lock == null ? true : contains(["CanNotDelete", "ReadOnly"], var.lock.kind)
    error_message = "lock.kind must be CanNotDelete or ReadOnly."
  }
}

variable "name" {
  description = "Name of the public IP address."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[a-zA-Z0-9_().-]{1,80}$", var.name)) && !endswith(var.name, ".")
    error_message = "name must contain 1 to 80 valid characters and must not end with a period."
  }
}

variable "public_ip_prefix_id" {
  description = "Resource ID of the public IP prefix from which to allocate the address."
  type        = string
  default     = null

  validation {
    condition     = var.public_ip_prefix_id == null || can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.Network/publicIPPrefixes/[^/]+$", var.public_ip_prefix_id))
    error_message = "public_ip_prefix_id must be a valid public IP prefix resource ID or null."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group where the public IP address will be deployed."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[a-zA-Z0-9_().-]{1,90}$", var.resource_group_name)) && !endswith(var.resource_group_name, ".")
    error_message = "resource_group_name must contain 1 to 90 valid characters and must not end with a period."
  }
}

variable "reverse_fqdn" {
  description = "Reverse FQDN for the public IP address."
  type        = string
  default     = null

  validation {
    condition     = var.reverse_fqdn == null || (length(var.reverse_fqdn) <= 253 && can(regex("^(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\\.)*[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?$", var.reverse_fqdn)))
    error_message = "reverse_fqdn must be a valid fully qualified domain name or null."
  }
}

variable "role_assignments" {
  description = "Role assignments to create on the public IP address."
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
  default  = {}
  nullable = false
}

variable "sku" {
  description = "SKU for the public IP address."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard"], var.sku)
    error_message = "sku must be Basic or Standard."
  }
}

variable "sku_tier" {
  description = "SKU tier for the public IP address."
  type        = string
  default     = "Regional"

  validation {
    condition     = contains(["Global", "Regional"], var.sku_tier)
    error_message = "sku_tier must be Global or Regional."
  }
}

variable "tags" {
  description = "Tags to apply to the public IP address."
  type        = map(string)
  default     = {}
}

variable "zones" {
  description = "Availability zones for the public IP address."
  type        = set(string)
  default = [
    1,
    2,
    3
  ]
}