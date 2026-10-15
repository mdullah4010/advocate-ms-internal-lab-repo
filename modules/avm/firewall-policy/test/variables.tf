variable "tenant_id" {
  description = "Microsoft Entra tenant ID used for the test deployment."
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID used for the test deployment."
  type        = string
}

variable "location" {
  description = "Azure region for the test resources."
  type        = string
}

variable "test_run_id" {
  description = "Unique identifier appended to temporary resource names."
  type        = string
}

variable "name" {
  description = "Name of the test Firewall Policy."
  type        = string
}

variable "resource_group_name" {
  description = "Optional resource group override. When null, the fixture resource group is used."
  type        = string
  default     = null
}

variable "diagnostic_settings" {
  description = "Diagnostic settings for the test Firewall Policy."
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
}

variable "enable_telemetry" {
  description = "Whether telemetry is enabled for the test Firewall Policy."
  type        = bool
}

variable "firewall_policy_auto_learn_private_ranges_enabled" {
  description = "Whether the test Firewall Policy automatically learns private ranges."
  type        = bool
  default     = null
}

variable "firewall_policy_base_policy_id" {
  description = "Optional base Firewall Policy ID."
  type        = string
  default     = null
}

variable "firewall_policy_dns" {
  description = "DNS proxy configuration for the test Firewall Policy."
  type = object({
    proxy_enabled = optional(bool)
    servers       = optional(list(string))
  })
  default = null
}

variable "firewall_policy_explicit_proxy" {
  description = "Explicit proxy configuration for the test Firewall Policy."
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
  description = "Managed identity configuration for the test Firewall Policy."
  type = object({
    identity_ids = optional(set(string))
    type         = string
  })
  default = null
}

variable "firewall_policy_insights" {
  description = "Insights configuration for the test Firewall Policy."
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
  description = "Intrusion detection configuration for the test Firewall Policy."
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
  description = "Private IP ranges for the test Firewall Policy."
  type        = list(string)
  default     = null
}

variable "firewall_policy_sku" {
  description = "SKU tier for the test Firewall Policy."
  type        = string
}

variable "firewall_policy_sql_redirect_allowed" {
  description = "Whether SQL redirect filtering is allowed by the test Firewall Policy."
  type        = bool
  default     = null
}

variable "firewall_policy_threat_intelligence_allowlist" {
  description = "Threat intelligence allowlist for the test Firewall Policy."
  type = object({
    fqdns        = optional(set(string))
    ip_addresses = optional(set(string))
  })
  default = null
}

variable "firewall_policy_threat_intelligence_mode" {
  description = "Threat intelligence mode for the test Firewall Policy."
  type        = string
  default     = null
}

variable "firewall_policy_timeouts" {
  description = "Timeouts for the test Firewall Policy."
  type = object({
    create = optional(string)
    delete = optional(string)
    read   = optional(string)
    update = optional(string)
  })
  default = null
}

variable "firewall_policy_tls_certificate" {
  description = "TLS certificate configuration for the test Firewall Policy."
  type = object({
    key_vault_secret_id = string
    name                = string
  })
  default = null
}

variable "lock" {
  description = "Optional management lock for the test Firewall Policy."
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null
}

variable "role_assignments" {
  description = "Role assignments for the test Firewall Policy."
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
}

variable "rule_collection_groups" {
  description = "Rule collection groups for the test Firewall Policy."
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
}

variable "tags" {
  description = "Tags applied to the temporary test resources."
  type        = map(string)
}