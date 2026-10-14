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
  description = "Name of the test private DNS resolver."
  type        = string
  default     = "dnspr-module-test"
}

variable "resource_group_name" {
  description = "Optional resource group name override. When null, the fixture resource group name is used."
  type        = string
  default     = null
}

variable "virtual_network_resource_id" {
  description = "Optional virtual network ID override. When null, the fixture virtual network ID is used."
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
  description = "Address space for the private DNS resolver test virtual network."
  type        = list(string)
  default     = ["10.254.0.0/16"]

  validation {
    condition     = length(var.address_space) > 0 && alltrue([for address in var.address_space : can(cidrnetmask(address))])
    error_message = "At least one valid CIDR address prefix must be provided."
  }
}

variable "enable_telemetry" {
  description = "Whether telemetry is enabled for the test private DNS resolver."
  type        = bool
  default     = false
}

variable "inbound_endpoints" {
  description = "Inbound endpoint sample. The fixture replaces subnet_name with its delegated inbound subnet."
  type = map(object({
    name                         = optional(string)
    subnet_name                  = string
    private_ip_allocation_method = optional(string, "Dynamic")
    private_ip_address           = optional(string, null)
    tags                         = optional(map(string), null)
    merge_with_module_tags       = optional(bool, true)
  }))
  default = {}
}

variable "lock" {
  description = "Optional management lock for the test private DNS resolver."
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null
}

variable "outbound_endpoints" {
  description = "Outbound endpoint sample. The fixture replaces subnet_name with its delegated outbound subnet."
  type = map(object({
    name                   = optional(string)
    tags                   = optional(map(string), null)
    merge_with_module_tags = optional(bool, true)
    subnet_name            = string
    forwarding_ruleset = optional(map(object({
      name                                                = optional(string)
      link_with_outbound_endpoint_virtual_network         = optional(bool, true)
      metadata_for_outbound_endpoint_virtual_network_link = optional(map(string), null)
      tags                                                = optional(map(string), null)
      merge_with_module_tags                              = optional(bool, true)
      additional_outbound_endpoint_link = optional(object({
        outbound_endpoint_key = optional(string)
      }), null)
      additional_virtual_network_links = optional(map(object({
        name     = optional(string)
        vnet_id  = string
        metadata = optional(map(string), null)
      })), {})
      rules = optional(map(object({
        name                     = optional(string)
        domain_name              = string
        destination_ip_addresses = map(string)
        enabled                  = optional(bool, true)
        metadata                 = optional(map(string), null)
      })))
    })))
  }))
  default = {}
}

variable "role_assignments" {
  description = "Role assignments for the test private DNS resolver."
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

variable "resolver_teardown_delay" {
  description = "Pause applied on destroy after the resolver is removed, giving Azure time to release the dnsResolverLink before the subnets are deleted."
  type        = string
  default     = "300s"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.resolver_teardown_delay))
    error_message = "Teardown delay must be a duration such as 300s, 5m, or 1h."
  }
}

variable "tags" {
  description = "Tags applied to the temporary test resources."
  type        = map(string)
  default = {
    environment = "test"
    managedBy   = "terraform"
    purpose     = "private-dns-resolver-module-test"
  }
}
