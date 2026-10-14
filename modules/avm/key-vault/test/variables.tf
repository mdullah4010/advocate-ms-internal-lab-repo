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
  default     = "westus3"
}

variable "name" {
  description = "Optional Key Vault name override."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "Optional resource group name override."
  type        = string
  default     = null
}

variable "module_tenant_id" {
  description = "Optional Key Vault tenant override; defaults to the CI tenant ID."
  type        = string
  default     = null
}

variable "test_run_id" {
  description = "Unique identifier used to derive temporary resource names."
  type        = string
}

variable "tags" {
  description = "Tags applied to the temporary test resources."
  type        = map(string)
  default = {
    environment = "test"
    managedBy   = "terraform"
    purpose     = "azure-key-vault-module-test"
  }
}

variable "contacts" {
  type    = any
  default = {}
}

variable "diagnostic_settings" {
  type    = any
  default = {}
}

variable "enable_telemetry" {
  type    = bool
  default = false
}

variable "enabled_for_deployment" {
  type    = bool
  default = false
}

variable "enabled_for_disk_encryption" {
  type    = bool
  default = false
}

variable "enabled_for_template_deployment" {
  type    = bool
  default = false
}

variable "keys" {
  type    = any
  default = {}
}

variable "legacy_access_policies" {
  type    = any
  default = {}
}

variable "legacy_access_policies_enabled" {
  type    = bool
  default = false
}

variable "lock" {
  type    = any
  default = null
}

variable "network_acls" {
  type    = any
  default = null
}

variable "private_endpoints" {
  type    = any
  default = {}
}

variable "private_endpoints_manage_dns_zone_group" {
  type    = bool
  default = false
}

variable "public_network_access_enabled" {
  type    = bool
  default = true
}

variable "purge_protection_enabled" {
  type    = bool
  default = false
}

variable "role_assignments" {
  type    = any
  default = {}
}

variable "secrets" {
  type    = any
  default = {}
}

variable "secrets_value" {
  type      = map(string)
  default   = {}
  sensitive = true
}

variable "secrets_value_wo" {
  type      = map(string)
  default   = null
  sensitive = true
  ephemeral = true
}

variable "secrets_value_wo_version" {
  type    = map(number)
  default = null
}

variable "sku_name" {
  type    = string
  default = "standard"
}

variable "soft_delete_retention_days" {
  type    = number
  default = null
}

variable "wait_for_rbac_before_contact_operations" {
  type    = any
  default = {}
}

variable "wait_for_rbac_before_key_operations" {
  type    = any
  default = {}
}

variable "wait_for_rbac_before_secret_operations" {
  type    = any
  default = {}
}
