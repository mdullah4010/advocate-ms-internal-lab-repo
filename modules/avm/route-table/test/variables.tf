variable "tenant_id" {
  description = "Microsoft Entra tenant ID used for the test deployment."
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID used for the test deployment."
  type        = string
}

variable "name" {
  description = "Optional route table name override; when null, the fixture-generated name is used."
  type        = string
  default     = null
}

variable "location" {
  description = "Azure region for the test resources."
  type        = string
  default     = "westus3"
}

variable "resource_group_name" {
  description = "Optional resource group name override; when null, the fixture resource group is used."
  type        = string
  default     = null
}

variable "test_run_id" {
  description = "Unique identifier appended to temporary resource names."
  type        = string
}

variable "address_space" {
  description = "Address space assigned to the test virtual network."
  type        = list(string)
  default     = ["10.253.0.0/16"]
}

variable "subnet_address_prefix" {
  description = "Address prefix assigned to the test subnet."
  type        = string
  default     = "10.253.1.0/24"
}

variable "route_address_prefix" {
  description = "Destination address prefix for the test route."
  type        = string
  default     = "10.254.0.0/16"
}

variable "bgp_route_propagation_enabled" {
  description = "Controls propagation of routes learned by BGP."
  type        = bool
  default     = true
}

variable "enable_telemetry" {
  description = "Controls whether telemetry is enabled for the route table module."
  type        = bool
  default     = false
}

variable "lock" {
  description = "Resource lock configuration for the route table."
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null
}

variable "role_assignments" {
  description = "Role assignments to create on the route table."
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

variable "routes" {
  description = "Additional routes merged with the fixture-generated route."
  type = map(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  default = {}
}

variable "routes_legacy_mode" {
  description = "Controls whether routes are managed in legacy mode."
  type        = bool
  default     = false
}

variable "subnet_resource_ids" {
  description = "Additional subnet resource IDs merged with the fixture-generated subnet association."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags applied to the temporary test resources."
  type        = map(string)
  default = {
    environment = "test"
    managedBy   = "terraform"
    purpose     = "route-table-module-test"
  }
}