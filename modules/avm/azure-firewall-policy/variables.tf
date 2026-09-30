variable "location" {
  description = "Azure region where the Firewall Policy will be created."
  type        = string
  nullable    = false
}

variable "name" {
  description = "Name of the Firewall Policy."
  type        = string
  nullable    = false

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 80 && can(regex("^[A-Za-z0-9]([A-Za-z0-9._-]*[A-Za-z0-9_])?$", var.name))
    error_message = "The Firewall Policy name must be 1-80 characters, start with an alphanumeric character, contain only alphanumerics, underscores, periods, or hyphens, and end with an alphanumeric character or underscore. See https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules"
  }
}

variable "resource_group_name" {
  description = "Name of the Resource Group where the Firewall Policy will be created."
  type        = string
  nullable    = false
}

variable "diagnostic_settings" {
  description = "Diagnostic settings to create for the Firewall Policy."
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

  validation {
    condition = alltrue([
      for setting in values(var.diagnostic_settings) : contains(["Dedicated", "AzureDiagnostics"], setting.log_analytics_destination_type)
    ])
    error_message = "Each diagnostic setting log_analytics_destination_type must be Dedicated or AzureDiagnostics."
  }

  validation {
    condition = alltrue([
      for setting in values(var.diagnostic_settings) : setting.workspace_resource_id != null || setting.storage_account_resource_id != null || setting.event_hub_authorization_rule_resource_id != null || setting.marketplace_partner_resource_id != null
    ])
    error_message = "Each diagnostic setting must specify at least one destination resource ID."
  }
}

variable "enable_telemetry" {
  description = "Controls whether telemetry is enabled for the AVM."
  type        = bool
  default     = true
  nullable    = false
}

variable "firewall_policy_auto_learn_private_ranges_enabled" {
  description = "Whether the Firewall Policy automatically learns private IP ranges."
  type        = bool
  default     = null
}

variable "firewall_policy_base_policy_id" {
  description = "ID of the base Firewall Policy."
  type        = string
  default     = null
}

variable "firewall_policy_dns" {
  description = "DNS proxy configuration for the Firewall Policy."
  type = object({
    proxy_enabled = optional(bool)
    servers       = optional(list(string))
  })
  default = null
}

variable "firewall_policy_explicit_proxy" {
  description = "Explicit proxy configuration for the Firewall Policy."
  type = object({
    enable_pac_file = optional(bool)
    enabled         = optional(bool)
    http_port       = optional(number)
    https_port      = optional(number)
    pac_file        = optional(string)
    pac_file_port   = optional(number)
  })
  default = null
}

variable "firewall_policy_identity" {
  description = "User-assigned managed identity configuration for the Firewall Policy."
  type = object({
    identity_ids = optional(set(string))
    type         = string
  })
  default = null
}

variable "firewall_policy_insights" {
  description = "Firewall Policy insights configuration."
  type = object({
    default_log_analytics_workspace_id = string
    enabled                            = bool
    retention_in_days                  = optional(number)
    log_analytics_workspace = optional(list(object({
      firewall_location = string
      id                = string
    })))
  })
  default = null
}

variable "firewall_policy_intrusion_detection" {
  description = "Intrusion detection configuration, including signature overrides and traffic bypass rules."
  type = object({
    mode           = optional(string)
    private_ranges = optional(list(string))
    signature_overrides = optional(list(object({
      id    = optional(string)
      state = optional(string)
    })))
    traffic_bypass = optional(list(object({
      description           = optional(string)
      destination_addresses = optional(set(string))
      destination_ip_groups = optional(set(string))
      destination_ports     = optional(set(string))
      name                  = string
      protocol              = string
      source_addresses      = optional(set(string))
      source_ip_groups      = optional(set(string))
    })))
  })
  default = null
}

variable "firewall_policy_private_ip_ranges" {
  description = "Private IP ranges to which traffic will not be SNATed."
  type        = list(string)
  default     = null
}

variable "firewall_policy_sku" {
  description = "Firewall Policy SKU tier: Standard, Premium, or Basic."
  type        = string
  default     = null
}

variable "firewall_policy_sql_redirect_allowed" {
  description = "Whether SQL Redirect traffic filtering is allowed."
  type        = bool
  default     = null
}

variable "firewall_policy_threat_intelligence_allowlist" {
  description = "FQDNs and IP ranges excluded from threat intelligence detection."
  type = object({
    fqdns        = optional(set(string))
    ip_addresses = optional(set(string))
  })
  default = null
}

variable "firewall_policy_threat_intelligence_mode" {
  description = "Threat intelligence mode: Alert, Deny, or Off."
  type        = string
  default     = null
}

variable "firewall_policy_timeouts" {
  description = "Create, delete, read, and update timeouts for the Firewall Policy."
  type = object({
    create = optional(string)
    delete = optional(string)
    read   = optional(string)
    update = optional(string)
  })
  default = null
}

variable "firewall_policy_tls_certificate" {
  description = "TLS certificate configuration referencing a Key Vault secret."
  type = object({
    key_vault_secret_id = string
    name                = string
  })
  default = null
}

variable "lock" {
  description = "Resource lock configuration for the Firewall Policy."
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

variable "role_assignments" {
  description = "Role assignments to create on the Firewall Policy."
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

variable "rule_collection_groups" {
  description = "Rule collection groups to create on this Firewall Policy, keyed by a unique map key."
  type = map(object({
    name     = string
    priority = number
    application_rule_collection = optional(list(object({
      action   = string
      name     = string
      priority = number
      rule = list(object({
        description           = optional(string)
        destination_addresses = optional(list(string), [])
        destination_fqdn_tags = optional(list(string), [])
        destination_fqdns     = optional(list(string), [])
        destination_urls      = optional(list(string), [])
        name                  = string
        source_addresses      = optional(list(string), [])
        source_ip_groups      = optional(list(string), [])
        terminate_tls         = optional(bool)
        web_categories        = optional(list(string), [])
        http_headers = optional(list(object({
          name  = string
          value = string
        })))
        protocols = optional(list(object({
          port = number
          type = string
        })))
      }))
    })))
    nat_rule_collection = optional(list(object({
      action   = string
      name     = string
      priority = number
      rule = list(object({
        description         = optional(string)
        destination_address = optional(string)
        destination_ports   = optional(list(string), [])
        name                = string
        protocols           = list(string)
        source_addresses    = optional(list(string), [])
        source_ip_groups    = optional(list(string), [])
        translated_address  = optional(string)
        translated_fqdn     = optional(string)
        translated_port     = number
      }))
    })))
    network_rule_collection = optional(list(object({
      action   = string
      name     = string
      priority = number
      rule = list(object({
        description           = optional(string)
        destination_addresses = optional(list(string), [])
        destination_fqdns     = optional(list(string), [])
        destination_ip_groups = optional(list(string), [])
        destination_ports     = list(string)
        name                  = string
        protocols             = list(string)
        source_addresses      = optional(list(string), [])
        source_ip_groups      = optional(list(string), [])
      }))
    })))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      read   = optional(string)
      update = optional(string)
    }))
  }))
  default  = {}
  nullable = false

  validation {
    condition     = alltrue([for group in values(var.rule_collection_groups) : group.priority >= 100 && group.priority <= 65000])
    error_message = "Each rule collection group priority must be between 100 and 65000."
  }
}

variable "tags" {
  description = "Tags to apply to the Firewall Policy."
  type        = map(string)
  default     = null
}