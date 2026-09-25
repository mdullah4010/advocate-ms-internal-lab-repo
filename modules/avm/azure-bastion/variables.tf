variable "location" {
  description = "Azure region for the Azure Bastion resources."
  type        = string
}
variable "name" {
  description = "Name of the Azure Bastion resource."
  type        = string
}
variable "parent_id" {
  description = "ID of the parent resource under which the Azure Bastion resource will be created."
  type        = string
}
variable "copy_paste_enabled" {
  description = "Indicates whether copy-paste functionality is enabled for the Azure Bastion resource."
  type        = bool
  default     = true
}
variable "diagnostic_settings" {
  description = "Diagnostic settings for the Azure Bastion resource."
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
  default = {}
}
variable "enable_telemetry" {
  description = "Indicates whether telemetry is enabled for the Azure Bastion resource."
  type        = bool
  default     = true
}
variable "file_copy_enabled" {
  description = "Indicates whether file copy functionality is enabled for the Azure Bastion resource. Requires the Standard or Premium SKU."
  type        = bool
  default     = false
}
variable "ip_configuration" {
  description = "IP configuration for the Azure Bastion resource."
  type = object({
    name                             = optional(string)
    subnet_id                        = string
    create_public_ip                 = optional(bool, true)
    public_ip_tags                   = optional(map(string), null)
    public_ip_merge_with_module_tags = optional(bool, true)
    public_ip_address_name           = optional(string, null)
    public_ip_address_id             = optional(string, null)
  })
  default = null
}
variable "ip_connect_enabled" {
  description = "Indicates whether IP connect functionality is enabled for the Azure Bastion resource."
  type        = bool
  default     = false
}
variable "kerberos_enabled" {
  description = "Indicates whether Kerberos functionality is enabled for the Azure Bastion resource."
  type        = bool
  default     = false
}
variable "lock" {
  description = "Indicates whether the Azure Bastion resource is locked."
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null
}
variable "private_only_enabled" {
  description = "Indicates whether the Azure Bastion resource is private only."
  type        = bool
  default     = false
}
variable "role_assignments" {
  description = "Role assignment for the Azure Bastion resource."
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
variable "scale_units" {
  description = "Indicates the scale unit for the Azure Bastion resource."
  type        = number
  default     = 2
}
variable "session_recording_enabled" {
  description = "Indicates whether session recording is enabled for the Azure Bastion resource."
  type        = bool
  default     = false
}
variable "shareable_link_enabled" {
  description = "Indicates whether shareable link functionality is enabled for the Azure Bastion resource. Requires the Standard or Premium SKU."
  type        = bool
  default     = false
}
variable "sku" {
  description = "Indicates the SKU for the Azure Bastion resource."
  type        = string
  default     = "Basic"

  validation {
    condition     = contains(["Developer", "Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU must be one of Developer, Basic, Standard, or Premium."
  }
}
variable "tags" {
  description = "Tags for the Azure Bastion resource."
  type        = map(string)
  default     = {}
}
variable "tunneling_enabled" {
  description = "Indicates whether tunneling functionality is enabled for the Azure Bastion resource."
  type        = bool
  default     = false
}
variable "virtual_network_id" {
  description = "Resource ID of the virtual network the Azure Bastion resource attaches to. Required for the Developer SKU only."
  type        = string
  default     = null
}
variable "zones" {
  description = "Indicates the availability zones for the Azure Bastion resource."
  type        = set(string)
  default = [
    "1",
    "2",
    "3"
  ]
}