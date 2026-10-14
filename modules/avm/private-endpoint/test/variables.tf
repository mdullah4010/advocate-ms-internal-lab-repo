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
  description = "Name of the test private endpoint."
  type        = string
  default     = "pe-storage-test"
}

variable "network_interface_name" {
  description = "Name of the test private endpoint network interface."
  type        = string
  default     = "nic-pe-storage-test"
}

variable "private_connection_resource_id" {
  description = "Optional private connection resource ID. When null, the fixture storage account ID is used."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "Optional resource group name. When null, the fixture resource group name is used."
  type        = string
  default     = null
}

variable "subnet_resource_id" {
  description = "Optional subnet resource ID. When null, the fixture private endpoint subnet ID is used."
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
  description = "Address space for the private endpoint test virtual network."
  type        = list(string)
  default     = ["10.252.0.0/16"]

  validation {
    condition     = length(var.address_space) > 0 && alltrue([for address in var.address_space : can(cidrnetmask(address))])
    error_message = "At least one valid CIDR address prefix must be provided."
  }
}

variable "application_security_group_association_ids" {
  description = "Application security group IDs associated with the test private endpoint."
  type        = set(string)
  default     = []
}

variable "enable_telemetry" {
  description = "Whether telemetry is enabled for the test private endpoint."
  type        = bool
  default     = false
}

variable "ip_configurations" {
  description = "Static IP configurations for the test private endpoint."
  type = map(object({
    name               = string
    private_ip_address = string
    subresource_name   = string
    member_name        = optional(string, "default")
  }))
  default = {}
}

variable "lock" {
  description = "Optional management lock for the test private endpoint."
  type = object({
    name = optional(string, null)
    kind = string
  })
  default = null
}

variable "private_dns_zone_group_name" {
  description = "Name of the test private DNS zone group."
  type        = string
  default     = "default"
}

variable "private_dns_zone_resource_ids" {
  description = "Optional private DNS zone IDs. When null, the fixture private DNS zone ID is used."
  type        = list(string)
  default     = null
}

variable "private_service_connection_name" {
  description = "Optional name of the test private service connection."
  type        = string
  default     = null
}

variable "role_assignments" {
  description = "Role assignments for the test private endpoint."
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

variable "subresource_names" {
  description = "Subresource names used by the test private service connection."
  type        = list(string)
  default     = ["blob"]
}

variable "tags" {
  description = "Tags applied to the temporary test resources."
  type        = map(string)
  default = {
    environment = "test"
    managedBy   = "terraform"
    purpose     = "private-endpoint-module-test"
  }
}
