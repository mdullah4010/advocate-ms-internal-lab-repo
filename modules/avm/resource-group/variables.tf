variable "name" {
  description = "Name of the Azure resource group."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_().-]{1,89}[a-zA-Z0-9_()-]$", var.name))
    error_message = "Resource group name must contain 1 to 90 valid characters and must not end with a period."
  }
}

variable "location" {
  description = "Azure region for the resource group."
  type        = string
  nullable    = false
}

variable "enable_telemetry" {
  description = "Controls whether telemetry is enabled for the AVM module."
  type        = bool
  default     = true
  nullable    = false
}

variable "lock" {
  description = "Resource lock configuration for the resource group."
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null

  validation {
    condition     = var.lock == null ? true : contains(["CanNotDelete", "ReadOnly"], var.lock.kind)
    error_message = "Lock kind must be CanNotDelete or ReadOnly."
  }
}

variable "managed_by" {
  description = "Resource ID of the resource or application that manages this resource group."
  type        = string
  default     = null

  validation {
    condition     = var.managed_by == null || can(regex("^/.+/.+", var.managed_by))
    error_message = "managed_by must be a valid Azure resource ID."
  }
}

variable "retry" {
  description = "Retry configuration applied to the resource group, lock, and role assignment operations."
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
  default  = {}
  nullable = false

  validation {
    condition = alltrue([
      for role in var.role_assignments :
      can(regex("^(/subscriptions/[0-9a-fA-F-]+)?/providers/Microsoft\\.Authorization/roleDefinitions/[0-9a-fA-F-]+$", role.role_definition_id_or_name)) ||
      can(regex("^[[:alpha:]]+?", role.role_definition_id_or_name))
    ])
    error_message = "role_definition_id_or_name must be a role name or a valid provider- or subscription-scoped role definition ID."
  }

  validation {
    condition = alltrue([
      for role in var.role_assignments :
      role.name == null || can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", coalesce(role.name, "00000000-0000-0000-0000-000000000000")))
    ])
    error_message = "Each role assignment name must be null or a valid GUID."
  }
}

variable "tags" {
  description = "Tags applied to the resource group."
  type        = map(string)
  default     = null
}

variable "timeouts" {
  description = "Timeouts applied to resource group, lock, and role assignment operations."
  type = object({
    create = optional(string, null)
    delete = optional(string, null)
    read   = optional(string, null)
    update = optional(string, null)
  })
  default  = {}
  nullable = false
}
