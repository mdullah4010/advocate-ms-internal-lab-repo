
variable "name" {
  description = "The name of the DDoS protection plan."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9_().-]{1,89}[a-zA-Z0-9_()-]$", var.name))
    error_message = "Resource group name must contain 1 to 90 valid characters and must not end with a period."
  }
}
variable "location" {
  description = "The location of the DDoS protection plan."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9_().-]{1,89}[a-zA-Z0-9_()-]$", var.location))
    error_message = "Location must contain 1 to 90 valid characters and must not end with a period."
  }
}
variable "resource_group_name" {
  description = "The name of the resource group for the DDoS protection plan."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9_().-]{1,89}[a-zA-Z0-9_()-]$", var.resource_group_name))
    error_message = "Resource group name must contain 1 to 90 valid characters and must not end with a period."
  }
}
variable "tags" {
  description = "The tags for the DDoS protection plan."
  type        = map(string)
  default     = {}
}
variable "enable_telemetry" {
  description = "Enable telemetry to collect usage data for the DDoS protection plan."
  type        = bool
  default     = true
}
variable "lock" {
  description = "Resource lock to lock the DDoS protection plan."
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null
}
variable "role_assignments" {
  description = "Role assignment to be created for the DDoS protection plan."
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
