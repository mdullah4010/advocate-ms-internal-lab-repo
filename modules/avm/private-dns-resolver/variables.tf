variable "location" {
  description = "The location where resources will be created."
  type        = string
}
variable "name" {
  description = "The name of the private DNS resolver."
  type        = string
}
variable "resource_group_name" {
  description = "The name of the resource group where the private DNS resolver will be created."
  type        = string
}
variable "virtual_network_resource_id" {
  description = "The resource ID of the virtual network to which the private DNS resolver will be linked."
  type        = string
}
variable "enable_telemetry" {
  description = "Whether to enable telemetry for the private DNS resolver."
  type        = bool
  default     = true
}
variable "inbound_endpoints" {
  description = "The configuration for the inbound endpoints of the private DNS resolver."
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
  description = "Whether to lock the private DNS resolver resource."
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null
}
variable "outbound_endpoints" {
  description = "The configuration for the outbound endpoints of the private DNS resolver."
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
  description = "The configuration for the role assignments of the private DNS resolver."
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
variable "tags" {
  description = "The tags to apply to the private DNS resolver resource."
  type        = map(string)
  default     = null
}
