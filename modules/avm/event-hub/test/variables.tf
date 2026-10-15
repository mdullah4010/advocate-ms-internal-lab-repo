variable "tenant_id" {
  description = "Microsoft Entra tenant ID used for the test deployment."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.tenant_id))
    error_message = "Tenant ID must be a GUID."
  }
}

variable "subscription_id" {
  description = "Azure subscription ID used for the test deployment."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.subscription_id))
    error_message = "Subscription ID must be a GUID."
  }
}

variable "location" {
  description = "Azure region for the test resources."
  type        = string
  default     = "westus3"
}

variable "name" {
  description = "Optional Event Hubs namespace name override."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "Optional resource group name override."
  type        = string
  default     = null
}

variable "test_run_id" {
  description = "Unique identifier used to name temporary test resources."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.test_run_id))
    error_message = "Test run ID may contain only letters, numbers, and hyphens."
  }
}

variable "tags" {
  description = "Tags applied to the temporary test resources."
  type        = map(string)
  default = {
    environment = "test"
    managedBy   = "terraform"
    purpose     = "event-hub-module-test"
  }
}

variable "customer_managed_key" {
  type    = any
  default = null
}

variable "diagnostic_settings" {
  type    = any
  default = {}
}

variable "enable_telemetry" {
  type    = bool
  default = false
}

variable "existing_parent_resource" {
  type    = any
  default = null
}

variable "ignore_body_changes" {
  type    = any
  default = {}
}

variable "lock" {
  type    = any
  default = null
}

variable "managed_identities" {
  type    = any
  default = {}
}

variable "private_endpoints" {
  type    = any
  default = {}
}

variable "private_endpoints_manage_dns_zone_group" {
  type    = bool
  default = false
}

variable "resource_types" {
  type    = any
  default = {}
}

variable "retry" {
  type    = any
  default = null
}

variable "role_assignments" {
  type    = any
  default = {}
}

variable "timeouts" {
  type    = any
  default = null
}

variable "auto_inflate_enabled" {
  type    = bool
  default = false
}

variable "capacity" {
  type    = number
  default = 1
}

variable "dedicated_cluster_id" {
  type    = string
  default = null
}

variable "local_authentication_enabled" {
  type    = bool
  default = false
}

variable "maximum_throughput_units" {
  type    = number
  default = null
}

variable "network_rulesets" {
  type    = any
  default = null
}

variable "public_network_access_enabled" {
  type    = bool
  default = true
}

variable "sku" {
  type    = string
  default = "Basic"
}

variable "event_hubs" {
  type    = any
  default = {}
}
