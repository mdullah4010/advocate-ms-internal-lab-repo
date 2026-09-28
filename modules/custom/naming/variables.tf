variable "resource_type" {
  description = "Resource type key from the Advocate Health abbreviation catalog."
  type        = string

  validation {
    condition = contains([
      "action_group",
      "application_insights",
      "application_registration",
      "automation_account",
      "azure_bastion",
      "azure_data_factory",
      "azure_firewall",
      "azure_machine_learning_workspace",
      "azure_openai_service",
      "backup_vault",
      "container_registry",
      "data_collection_rule",
      "databricks_workspace",
      "dns_private_resolver",
      "expressroute_circuit",
      "firewall_policy",
      "key_vault",
      "log_analytics_workspace",
      "managed_devops_pool",
      "managed_identity",
      "management_group",
      "network_security_group",
      "policy_assignment",
      "policy_definition",
      "policy_exemption",
      "policy_initiative",
      "private_endpoint",
      "public_ip",
      "recovery_services_vault",
      "resource_group",
      "route_table",
      "service_principal",
      "storage_account",
      "subnet",
      "virtual_machine",
      "virtual_machine_scale_set",
      "virtual_network",
      "virtual_network_gateway",
    ], var.resource_type)
    error_message = "resource_type must be a key from the Advocate Health abbreviation catalog."
  }
}

variable "org_code" {
  description = "Approved lowercase organization code from the controlled organization registry."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.org_code)) && contains(var.organization_codes, var.org_code)
    error_message = "org_code must contain only lowercase letters and numbers and must exist in organization_codes."
  }
}

variable "organization_codes" {
  description = "Controlled registry of approved lowercase organization codes."
  type        = set(string)

  validation {
    condition     = length(var.organization_codes) > 0 && alltrue([for code in var.organization_codes : can(regex("^[a-z0-9]+$", code))])
    error_message = "organization_codes must contain at least one code, and every code must use only lowercase letters and numbers."
  }
}

variable "workload" {
  description = "Approved lowercase workload or platform-function code."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.workload)) && contains(var.workload_codes, var.workload)
    error_message = "workload must contain only lowercase letters and numbers and must exist in workload_codes."
  }
}

variable "workload_codes" {
  description = "Controlled registry of approved lowercase workload and platform-function codes."
  type        = set(string)

  validation {
    condition     = length(var.workload_codes) > 0 && alltrue([for code in var.workload_codes : can(regex("^[a-z0-9]+$", code))])
    error_message = "workload_codes must contain at least one code, and every code must use only lowercase letters and numbers."
  }
}

variable "purpose" {
  description = "Optional approved lowercase purpose code used by the extended naming pattern."
  type        = string
  default     = null

  validation {
    condition     = (var.purpose == null || can(regex("^[a-z0-9]+$", var.purpose))) && (var.resource_type != "resource_group" || var.purpose != null)
    error_message = "purpose must contain only lowercase letters and numbers and is required for resource_group names."
  }
}

variable "region_code" {
  description = "Approved Azure region code. Use glb for genuinely global or non-regional resources."
  type        = string

  validation {
    condition     = contains(["eus", "eus2", "cus", "ncus", "scus", "wcus", "wus", "wus2", "wus3", "glb"], var.region_code)
    error_message = "region_code must be one of eus, eus2, cus, ncus, scus, wcus, wus, wus2, wus3, or glb."
  }
}

variable "environment_code" {
  description = "Approved Advocate Health Azure cloud and environment code."
  type        = string

  validation {
    condition     = contains(["azp", "azn", "azi", "azx", "azdr", "azc"], var.environment_code)
    error_message = "environment_code must be one of azp, azn, azi, azx, azdr, or azc. Reserved codes require governance approval before use."
  }
}

variable "instance" {
  description = "Resource instance number. Values 1 through 99 are formatted with two digits; values 100 through 999 use three digits."
  type        = number
  default     = 1

  validation {
    condition     = var.instance >= 1 && var.instance <= 999 && floor(var.instance) == var.instance
    error_message = "instance must be a whole number from 1 through 999."
  }
}

variable "uniqueness_suffix" {
  description = "Optional deterministic lowercase alphanumeric suffix for globally unique resources."
  type        = string
  default     = null

  validation {
    condition     = var.uniqueness_suffix == null || can(regex("^[a-z0-9]+$", var.uniqueness_suffix))
    error_message = "uniqueness_suffix must be null or contain only lowercase letters and numbers."
  }
}
