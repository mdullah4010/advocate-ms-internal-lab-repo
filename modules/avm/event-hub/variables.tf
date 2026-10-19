variable "location" {
  type        = string
  description = "Azure region where the Event Hubs namespace should be deployed."
  nullable    = false
}

variable "name" {
  type        = string
  description = "Name of the Event Hubs namespace."

  validation {
    condition     = can(regex("[a-zA-Z][a-zA-Z0-9-]{0,48}[a-zA-Z0-9]$", var.name))
    error_message = "The name must be between 2 and 50 characters, contain only alphanumeric characters and hyphens, start with a letter, and not end with a hyphen."
  }
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where the Event Hubs namespace is deployed."
}

variable "customer_managed_key" {
  type = object({
    key_vault_resource_id = string
    key_name              = string
    key_version           = optional(string, null)
    user_assigned_identity = optional(object({
      resource_id = string
    }), null)
  })
  default     = null
  description = "Customer-managed key configuration supported by the AVM interface."
}

variable "diagnostic_settings" {
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
  default     = {}
  description = "Map of diagnostic settings to apply to the Event Hubs namespace."
  nullable    = false

  validation {
    condition = alltrue([
      for setting in values(var.diagnostic_settings) :
      contains(["Dedicated", "AzureDiagnostics"], setting.log_analytics_destination_type)
    ])
    error_message = "Log analytics destination type must be 'Dedicated' or 'AzureDiagnostics'."
  }
  validation {
    condition = alltrue([
      for setting in values(var.diagnostic_settings) :
      setting.workspace_resource_id != null ||
      setting.storage_account_resource_id != null ||
      setting.event_hub_authorization_rule_resource_id != null ||
      setting.marketplace_partner_resource_id != null
    ])
    error_message = "Each diagnostic setting must specify at least one destination resource ID."
  }
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = "Whether telemetry is enabled for the AVM."
  nullable    = false
}

variable "existing_parent_resource" {
  type = object({
    name = string
  })
  default     = null
  description = "Existing Event Hubs namespace to use for child resources instead of creating a namespace."
}

variable "ignore_body_changes" {
  type = object({
    authorization_locks            = optional(list(string), [])
    authorization_role_assignments = optional(list(string), [])
  })
  default     = {}
  description = "Body-relative paths to ignore for supported AzAPI resources."
  nullable    = false
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = "Resource lock configuration for the namespace."

  validation {
    condition     = var.lock == null ? true : contains(["CanNotDelete", "ReadOnly"], var.lock.kind)
    error_message = "Lock kind must be 'CanNotDelete' or 'ReadOnly'."
  }
}

variable "managed_identities" {
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  default     = {}
  description = "Managed identity configuration supported by the AVM interface."
  nullable    = false
}

variable "private_endpoints" {
  type = map(object({
    name = optional(string, null)
    role_assignments = optional(map(object({
      name                                   = optional(string, null)
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    })), {})
    lock = optional(object({
      kind  = string
      name  = optional(string, null)
      notes = optional(string, null)
    }), null)
    tags                                    = optional(map(string), null)
    subnet_resource_id                      = string
    private_dns_zone_group_name             = optional(string, null)
    private_dns_zone_resource_ids           = optional(set(string), [])
    application_security_group_associations = optional(map(string), {})
    private_service_connection_name         = optional(string, null)
    network_interface_name                  = optional(string, null)
    location                                = optional(string, null)
    resource_group_name                     = optional(string, null)
    ip_configurations = optional(map(object({
      name               = string
      private_ip_address = string
      member_name        = optional(string)
    })), {})
  }))
  default     = {}
  description = "Map of private endpoints to create for the Event Hubs namespace."
  nullable    = false
}

variable "private_endpoints_manage_dns_zone_group" {
  type        = bool
  default     = true
  description = "Whether this module manages private DNS zone groups for private endpoints."
  nullable    = false
}

variable "resource_types" {
  type = object({
    authorization_locks            = optional(string, "Microsoft.Authorization/locks@2020-05-01")
    authorization_role_assignments = optional(string, "Microsoft.Authorization/roleAssignments@2022-04-01")
  })
  default     = {}
  description = "AzAPI resource types and API versions used by the module."
  nullable    = false
}

variable "retry" {
  type = object({
    error_message_regex  = optional(list(string))
    interval_seconds     = optional(number)
    max_interval_seconds = optional(number)
  })
  default     = null
  description = "Retry configuration applied to supported AzAPI resources."
}

variable "role_assignments" {
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
  default     = {}
  description = "Map of role assignments to create on the Event Hubs namespace."
  nullable    = false
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Tags to apply to the Event Hubs namespace."
}

variable "timeouts" {
  type = object({
    create = optional(string)
    read   = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default     = null
  description = "Per-operation timeouts applied to supported AzAPI resources."
}

variable "auto_inflate_enabled" {
  type        = bool
  default     = false
  description = "Whether Auto Inflate is enabled for the Event Hubs namespace."
}

variable "capacity" {
  type        = number
  default     = 1
  description = "Capacity in throughput units for a Standard SKU namespace."
}

variable "dedicated_cluster_id" {
  type        = string
  default     = null
  description = "ID of the Event Hubs dedicated cluster for this namespace."
}

variable "local_authentication_enabled" {
  type        = bool
  default     = false
  description = "Whether SAS authentication is enabled for the Event Hubs namespace."
}

variable "maximum_throughput_units" {
  type        = number
  default     = null
  description = "Maximum throughput units when Auto Inflate is enabled, from 1 to 20."

  # validation {
  #   condition     = var.maximum_throughput_units == null ? true : var.maximum_throughput_units >= 1 && var.maximum_throughput_units <= 20
  #   error_message = "Maximum throughput units must be in the range of 1 to 20."
  # }
}

variable "network_rulesets" {
  type = object({
    default_action                 = optional(string, "Deny")
    public_network_access_enabled  = bool
    trusted_service_access_enabled = bool
    ip_rule = optional(list(object({
      action  = optional(string, "Allow")
      ip_mask = string
    })), [])
    virtual_network_rule = optional(list(object({
      ignore_missing_virtual_network_service_endpoint = optional(bool)
      subnet_id                                       = string
    })), [])
  })
  default     = null
  description = "Network rule set for the namespace. Premium SKU is required by the upstream AVM."

  validation {
    condition     = var.network_rulesets == null ? true : contains(["Allow", "Deny"], var.network_rulesets.default_action)
    error_message = "Network ruleset default_action must be 'Allow' or 'Deny'."
  }
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Whether public network access is enabled for the namespace."
}

variable "sku" {
  type        = string
  default     = "Standard"
  description = "SKU tier for the Event Hubs namespace: Basic, Standard, or Premium."

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU must be 'Basic', 'Standard', or 'Premium'."
  }
}

variable "event_hubs" {
  type = map(object({
    namespace_name      = string
    resource_group_name = string
    partition_count     = number
    message_retention   = number
    capture_description = optional(object({
      enabled             = bool
      encoding            = string
      interval_in_seconds = optional(number)
      size_limit_in_bytes = optional(number)
      skip_empty_archives = optional(bool)
      destination = object({
        name                = optional(string, "EventHubArchive.AzureBlockBlob")
        archive_name_format = string
        blob_container_name = string
        storage_account_id  = string
      })
    }))
    status = optional(string)
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
    })), {})
  }))
  default     = {}
  description = "Map of Event Hubs to create in the namespace, keyed by Event Hub name."
}
