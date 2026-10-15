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
  description = "Name of the test Azure Bastion host."
  type        = string
  default     = "bas-module-test"
}

variable "parent_id" {
  description = "Optional parent resource ID. When null, the test resource group ID is used."
  type        = string
  default     = null
}

variable "test_run_id" {
  description = "Unique identifier appended to temporary resource names."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.test_run_id))
    error_message = "Test run ID may contain only letters, numbers, and hyphens."
  }
}

variable "address_space" {
  description = "Address space for the Azure Bastion test virtual network."
  type        = list(string)
  default     = ["10.251.0.0/16"]

  validation {
    condition     = length(var.address_space) > 0 && alltrue([for address in var.address_space : can(cidrnetmask(address))])
    error_message = "At least one valid CIDR address prefix must be provided."
  }
}

variable "copy_paste_enabled" {
  description = "Whether copy and paste is enabled for the test Azure Bastion host."
  type        = bool
  default     = true
}

variable "diagnostic_settings" {
  description = "Diagnostic settings for the test Azure Bastion host."
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
  description = "Whether telemetry is enabled for the test Azure Bastion host."
  type        = bool
  default     = false
}

variable "file_copy_enabled" {
  description = "Whether file copy is enabled for the test Azure Bastion host."
  type        = bool
  default     = false
}

variable "ip_configuration" {
  description = "IP configuration sample. The fixture replaces subnet_id with the test subnet ID."
  type = object({
    name                             = optional(string)
    subnet_id                        = string
    create_public_ip                 = optional(bool, true)
    public_ip_tags                   = optional(map(string), null)
    public_ip_merge_with_module_tags = optional(bool, true)
    public_ip_address_name           = optional(string, null)
    public_ip_address_id             = optional(string, null)
  })
}

variable "ip_connect_enabled" {
  description = "Whether IP-based connections are enabled for the test Azure Bastion host."
  type        = bool
  default     = false
}

variable "kerberos_enabled" {
  description = "Whether Kerberos authentication is enabled for the test Azure Bastion host."
  type        = bool
  default     = false
}

variable "lock" {
  description = "Optional management lock for the test Azure Bastion host."
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null
}

variable "private_only_enabled" {
  description = "Whether the test Azure Bastion host is private-only."
  type        = bool
  default     = false
}

variable "role_assignments" {
  description = "Role assignments for the test Azure Bastion host."
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
  description = "Scale units for the test Azure Bastion host."
  type        = number
  default     = 2
}

variable "session_recording_enabled" {
  description = "Whether session recording is enabled for the test Azure Bastion host."
  type        = bool
  default     = false
}

variable "shareable_link_enabled" {
  description = "Whether shareable links are enabled for the test Azure Bastion host."
  type        = bool
  default     = false
}

variable "sku" {
  description = "SKU used for the test Azure Bastion host."
  type        = string
  default     = "Basic"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "Test SKU must be Basic, Standard, or Premium. The Developer SKU has no subnet and is not covered by this fixture."
  }
}

variable "zones" {
  description = "Availability zones for the test Azure Bastion host. Defaults to empty because zone-redundant Bastion is only offered in a subset of regions."
  type        = set(string)
  default     = []

  validation {
    condition     = alltrue([for zone in var.zones : contains(["1", "2", "3"], zone)])
    error_message = "Zones may only contain 1, 2, or 3."
  }
}

variable "tags" {
  description = "Tags applied to the temporary test resources."
  type        = map(string)
  default = {
    environment = "test"
    managedBy   = "terraform"
    purpose     = "azure-bastion-module-test"
  }
}

variable "tunneling_enabled" {
  description = "Whether native client tunneling is enabled for the test Azure Bastion host."
  type        = bool
  default     = false
}

variable "virtual_network_id" {
  description = "Virtual network ID used by the Developer SKU."
  type        = string
  default     = null
}
