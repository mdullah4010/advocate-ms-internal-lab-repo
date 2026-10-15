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

variable "name" {
  description = "Optional resource group name override; when null, the fixture-generated name is used."
  type        = string
  default     = null
}

variable "location" {
  description = "Azure region for the test resource group."
  type        = string
  default     = "westus3"
}

variable "test_run_id" {
  description = "Unique identifier appended to the temporary resource group name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.test_run_id))
    error_message = "Test run ID may contain only letters, numbers, and hyphens."
  }
}

variable "tags" {
  description = "Tags applied to the temporary test resource group."
  type        = map(string)
  default = {
    environment = "test"
    managedBy   = "terraform"
    purpose     = "resource-group-module-test"
  }
}

variable "enable_telemetry" {
  description = "Controls whether telemetry is enabled for the resource group module."
  type        = bool
  default     = false
}

variable "lock" {
  description = "Resource lock configuration for the resource group."
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null
}

variable "managed_by" {
  description = "Resource ID of the resource or application managing the resource group."
  type        = string
  default     = null
}

variable "retry" {
  description = "Retry configuration for resource group operations."
  type = object({
    error_message_regex  = optional(list(string), ["409 Conflict"])
    interval_seconds     = optional(number, null)
    max_interval_seconds = optional(number, null)
  })
  default = {}
}

variable "role_assignments" {
  description = "Role assignments to create on the resource group."
  type = map(object({
    name                                   = optional(string, null)
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

variable "timeouts" {
  description = "Timeouts for resource group operations."
  type = object({
    create = optional(string, null)
    delete = optional(string, null)
    read   = optional(string, null)
    update = optional(string, null)
  })
  default = {}
}
