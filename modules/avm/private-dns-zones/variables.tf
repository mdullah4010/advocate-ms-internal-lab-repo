variable "location" {
  description = "The location where private link private DNS zones and Resource Group will be deployed."
  type        = string
}

variable "parent_id" {
    description = "The resource ID of the existing Resource Group."
    type        = string
}

variable "enable_telemetry" {
    description = "Flag to enable or disable telemetry."
    type        = bool
    default     = true
}

variable "lock" {
    description = "Controls the Resource Lock configuration for the Resource Group that hosts the private link private DNS zones."
    type        = object({
    kind = string
    name = optional(string, null)
  })
    default     = null
}

variable "private_link_excluded_zones"{
    description = "Set of private link private DNS zones to be excluded."
    type        = set(string)
    default     = []
}

variable "private_link_private_dns_zones" {
    description = "Set of private link private DNS zones to be created."
    type        = map(object({
    zone_name                              = optional(string, null)
    private_dns_zone_supports_private_link = optional(bool, true)
    custom_iterator = optional(object({
      replacement_placeholder = string
      replacement_values      = map(string)
    }))
    resolution_policy = optional(string, null)
  }))
    default     = {}
}

variable "private_link_private_dns_zone_additional" {
    description = " A set of private link private DNS zones to create in addition to the zones supplied in private_link_private_dns_zones"
    type        = map(object({
    zone_name                              = optional(string, null)
    private_dns_zone_supports_private_link = optional(bool, true)
    custom_iterator = optional(object({
      replacement_placeholder = string
      replacement_values      = map(string)
    }))
    resolution_policy = optional(string, null)
  }))
    default     = {}
}

variable "private_link_private_dns_zone_regex_filter" {
    description = "Variable controls whether or not the private link private DNS zones should be filtered based on the zone name"
    type        = object({
    enabled      = optional(bool, false)
    regex_filter = optional(string, "{regionName}|{regionCode}")
  })
    default     = {}
}

variable "resource_group_role_assignments"{
    description = "Role assignments for the resource group."
    type        = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    principal_type                         = optional(string, null)
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
  }))
    default     = {}
}

variable "tags" {
    description = "Tags to be applied to the resource group."
    type        = map(string)
    default     = null
}

variable "timeouts"{
    description = "map of timeouts objects, per resource type, to apply to the creation and destruction of resources the following resourcesTimeouts for the resource group operations."
    type        = object({
    dns_zones = optional(object({
      create = optional(string, "30m")
      delete = optional(string, "30m")
      update = optional(string, "30m")
      read   = optional(string, "5m")
      }), {}
    )
    vnet_links = optional(object({
      create = optional(string, "30m")
      delete = optional(string, "30m")
      update = optional(string, "30m")
      read   = optional(string, "5m")
      }), {}
    )
  })

    default     = {}
}

variable "virtual_network_link_additional_virtual_networks" {
    description = "Map of objects of Virtual Network Resource IDs to link to all the private link private DNS zones created."
    type        = map(object({
    virtual_network_resource_id                 = optional(string)
    virtual_network_link_name_template_override = optional(string)
    resolution_policy                           = optional(string)
  }))

    default     = {}
}

variable "virtual_network_link_by_zone_and_virtual_network"{
    description = "Map of objects of Virtual Network Resource IDs to link to specific private link private DNS zones."
    type        = map(map(object({
    virtual_network_resource_id = optional(string)
    name                        = optional(string)
    resolution_policy           = optional(string)
  })))

    default     = {}
}

variable "virtual_network_link_default_virtual_networks"{
  description = "map of objects of Virtual Network Resource IDs to link to all the private link private DNS zones created." 
  type = map(object({
    virtual_network_resource_id                 = optional(string)
    virtual_network_link_name_template_override = optional(string)
    resolution_policy                           = optional(string)
  }))
    default     = {}
}

variable "virtual_network_link_name_template"{
    description = "Template for naming virtual network links created."
    type        = string
  default     = "vnet_link-$${zone_key}-$${vnet_key}"
}

variable "virtual_network_link_overrides_by_virtual_network"{
    description = "Map of objects to override virtual network link applied per virtual network."
    type        = map(object({
    virtual_network_link_name_template_override = optional(string)
    resolution_policy                           = optional(string)
    enabled                                     = optional(bool, true)
  }))
    default     = {}
}

variable "virtual_network_link_overrides_by_zone"{
    description = "Map of objects to override virtual network link applied per private DNS zone."
    type        = map(object({
    virtual_network_link_name_template_override = optional(string)
    resolution_policy                           = optional(string)
    enabled                                     = optional(bool, true)
  }))
    default     = {}
}

variable "virtual_network_link_overrides_by_zone_and_virtual_network"{
    description = "Map of objects to override virtual network link applied per private DNS zone and per virtual network."
    type        = map(map(object({
    name              = optional(string)
    resolution_policy = optional(string)
    enabled           = optional(bool, true)
  })))
    default     = {}
}

variable "virtual_network_link_resolution_policy_default"{
    description = "Default resolution policy for virtual network links created."
    type        = string
    default     = "Default"
}