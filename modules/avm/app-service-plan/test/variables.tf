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

variable "test_run_id" {
  description = "Unique identifier appended to temporary resource names."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.test_run_id))
    error_message = "Test run ID may contain only letters, numbers, and hyphens."
  }
}

variable "os_type" {
  description = "The operating system type of the App Service Plan."
  type        = string
  default     = "Linux"
}

variable "app_service_environment_id" {
  description = "Optional App Service Environment resource ID."
  type        = string
  default     = null
}

variable "async_scaling_enabled" {
  description = "Whether asynchronous scaling is enabled."
  type        = bool
  default     = null
}

variable "diagnostic_settings" {
  description = "Diagnostic settings to configure for the App Service Plan."
  type = map(object({
    name = optional(string, null)
    logs = optional(set(object({
      category       = optional(string, null)
      category_group = optional(string, null)
      enabled        = optional(bool, true)
      retention_policy = optional(object({
        days    = optional(number, 0)
        enabled = optional(bool, false)
      }), {})
    })), [])
    metrics = optional(set(object({
      category = optional(string, null)
      enabled  = optional(bool, true)
      retention_policy = optional(object({
        days    = optional(number, 0)
        enabled = optional(bool, false)
      }), {})
    })), [])
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
  description = "Whether module telemetry is enabled."
  type        = bool
  default     = true
}

variable "install_scripts" {
  description = "Install scripts for a Windows Managed Instance plan."
  type = list(object({
    name = string
    source = object({
      type       = optional(string, "RemoteAzureBlob")
      source_uri = string
    })
  }))
  default = null
}

variable "lock" {
  description = "Resource lock configuration."
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null
}

variable "managed_identities" {
  description = "Managed identity configuration for the App Service Plan."
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  default = {}
}

variable "maximum_elastic_worker_count" {
  description = "Maximum number of workers for an elastic plan."
  type        = number
  default     = 3
}

variable "per_site_scaling_enabled" {
  description = "Whether per-site scaling is enabled."
  type        = bool
  default     = false
}

variable "plan_default_identity" {
  description = "Default identity configuration for a Windows Managed Instance plan."
  type = object({
    identity_type                      = optional(string, "UserAssigned")
    user_assigned_identity_resource_id = string
  })
  default = null
}

variable "premium_plan_auto_scale_enabled" {
  description = "Whether elastic scale is enabled for a Premium plan."
  type        = bool
  default     = false
}

variable "rdp_enabled" {
  description = "Whether RDP is enabled for a Windows Managed Instance plan."
  type        = bool
  default     = null
}

variable "registry_adapters" {
  description = "Registry adapters for a Windows Managed Instance plan."
  type = list(object({
    registry_key = string
    type         = string
    key_vault_secret_reference = object({
      secret_uri = string
    })
  }))
  default = null
}

variable "retry" {
  description = "Retry configuration for AzAPI resources."
  type = object({
    error_message_regex  = optional(list(string), ["ScopeLocked"])
    interval_seconds     = optional(number, null)
    max_interval_seconds = optional(number, null)
  })
  default = null
}

variable "role_assignments" {
  description = "Role assignments to create on the App Service Plan."
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

variable "server_farm_resource_type" {
  description = "Resource type and API version for the server farm."
  type        = string
  default     = "Microsoft.Web/serverfarms@2025-03-01"
}

variable "sku_name" {
  description = "The SKU name of the App Service Plan."
  type        = string
  default     = "P1v2"
}

variable "storage_mounts" {
  description = "Storage mounts for a Windows Managed Instance plan."
  type = list(object({
    name             = string
    type             = optional(string, "LocalStorage")
    source           = optional(string, "")
    destination_path = string
    credentials_key_vault_reference = optional(object({
      secret_uri = optional(string)
    }), {})
  }))
  default = null
}

variable "tags" {
  description = "Tags to apply to the App Service Plan."
  type        = map(string)
  default     = null
}

variable "timeouts" {
  description = "Timeout configuration for AzAPI resources."
  type = object({
    create = optional(string, null)
    delete = optional(string, null)
    read   = optional(string, null)
    update = optional(string, null)
  })
  default = null
}

variable "virtual_network_subnet_id" {
  description = "Optional subnet resource ID for VNet integration."
  type        = string
  default     = null
}

variable "worker_count" {
  description = "Number of workers allocated to the App Service Plan."
  type        = number
  default     = 3
}

variable "zone_balancing_enabled" {
  description = "Whether zone balancing is enabled."
  type        = bool
  default     = true
}
