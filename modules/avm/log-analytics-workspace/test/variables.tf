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
  description = "Optional Log Analytics Workspace name override."
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
    purpose     = "log-analytics-workspace-module-test"
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

variable "lock" {
  type    = any
  default = null
}

variable "log_analytics_workspace_allow_resource_only_permissions" {
  type    = bool
  default = null
}

variable "log_analytics_workspace_cmk_for_query_forced" {
  type    = bool
  default = null
}

variable "log_analytics_workspace_daily_quota_gb" {
  type    = number
  default = null
}

variable "log_analytics_workspace_data_exports" {
  type    = any
  default = {}
}

variable "log_analytics_workspace_dedicated_cluster_resource_id" {
  type    = string
  default = null
}

variable "log_analytics_workspace_identity" {
  type    = any
  default = null
}

variable "log_analytics_workspace_internet_ingestion_enabled" {
  type    = string
  default = "false"
}

variable "log_analytics_workspace_internet_query_enabled" {
  type    = string
  default = "false"
}

variable "log_analytics_workspace_linked_storage_accounts" {
  type    = any
  default = {}
}

variable "log_analytics_workspace_local_authentication_enabled" {
  type    = bool
  default = true
}

variable "log_analytics_workspace_reservation_capacity_in_gb_per_day" {
  type    = number
  default = null
}

variable "log_analytics_workspace_retention_in_days" {
  type    = number
  default = null
}

variable "log_analytics_workspace_sku" {
  type    = string
  default = null
}

variable "log_analytics_workspace_tables" {
  type    = any
  default = {}
}

variable "log_analytics_workspace_tables_update" {
  type    = any
  default = {}
}

variable "log_analytics_workspace_timeouts" {
  type    = any
  default = null
}

variable "monitor_private_link_scope" {
  type    = any
  default = {}
}

variable "monitor_private_link_scoped_resource" {
  type    = any
  default = {}
}

variable "monitor_private_link_scoped_service_name" {
  type    = string
  default = null
}

variable "network_security_perimeter_association" {
  type    = any
  default = null
}

variable "private_endpoint_extensions" {
  type    = any
  default = {}
}

variable "private_endpoints" {
  type    = any
  default = {}
}

variable "role_assignments" {
  type    = any
  default = {}
}
