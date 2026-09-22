variable "location" {
  description = "Azure region where the virtual network will be created."
  type        = string
  nullable    = false
}

variable "parent_id" {
  description = "Resource ID of the resource group where the virtual network will be deployed."
  type        = string

  validation {
    condition     = can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+$", var.parent_id))
    error_message = "parent_id must be a valid resource group ID."
  }
}

variable "address_space" {
  description = "Address spaces assigned to the virtual network. Specify either address_space or ipam_pools, but not both."
  type        = set(string)
  default     = null

  validation {
    condition     = (var.address_space != null && var.ipam_pools == null) || (var.address_space == null && var.ipam_pools != null)
    error_message = "Either address_space or ipam_pools must be specified, but not both."
  }

  validation {
    condition     = var.address_space == null ? true : alltrue([for cidr in var.address_space : can(cidrhost(cidr, 0))])
    error_message = "Each entry in address_space must be a valid CIDR block."
  }
}

variable "bgp_community" {
  description = "BGP community to send to the virtual network gateway."
  type        = string
  default     = null
}

variable "ddos_protection_plan" {
  description = "DDoS protection plan configuration."
  type = object({
    id     = string
    enable = bool
  })
  default = null
}

variable "diagnostic_settings" {
  description = "Diagnostic settings to create for the virtual network."
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
}

variable "dns_servers" {
  description = "Custom DNS server configuration for the virtual network."
  type = object({
    dns_servers = list(string)
  })
  default = null
}

variable "enable_telemetry" {
  description = "Controls whether telemetry is enabled for the AVM module."
  type        = bool
  default     = true
  nullable    = false
}

variable "enable_vm_protection" {
  description = "Enables VM protection for the virtual network."
  type        = bool
  default     = false
}

variable "encryption" {
  description = "Virtual network encryption settings."
  type = object({
    enabled     = bool
    enforcement = string
  })
  default = null
}

variable "extended_location" {
  description = "Extended location settings for the virtual network."
  type = object({
    name = string
    type = string
  })
  default = null
}

variable "flow_timeout_in_minutes" {
  description = "Flow timeout in minutes for the virtual network."
  type        = number
  default     = null
}

variable "ignore_body_changes" {
  description = "AzAPI body paths whose out-of-band changes should be ignored for the virtual network, subnets, and peerings."
  type = object({
    virtual_networks = optional(list(string), [])
    virtual_networks_subnets = optional(object({
      virtual_networks_subnets = optional(list(string), [])
    }), {})
    virtual_networks_virtual_network_peerings = optional(object({
      virtual_networks_virtual_network_peerings = optional(list(string), [])
    }), {})
  })
  default  = {}
  nullable = false
}

variable "ipam_pools" {
  description = "IPAM pools from which the virtual network address space will be allocated."
  type = list(object({
    id                     = string
    number_of_ip_addresses = optional(string)
    prefix_length          = optional(number)
  }))
  default = null
}

variable "lock" {
  description = "Resource lock configuration for the virtual network."
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null
}

variable "name" {
  description = "Name of the Azure virtual network."
  type        = string
  default     = null
}

variable "peerings" {
  description = "Virtual network peerings to create, including optional reverse peerings and partial address-space or subnet peering."
  type = map(object({
    name                               = string
    remote_virtual_network_resource_id = string
    allow_forwarded_traffic            = optional(bool, false)
    allow_gateway_transit              = optional(bool, false)
    allow_virtual_network_access       = optional(bool, true)
    do_not_verify_remote_gateways      = optional(bool, false)
    enable_only_ipv6_peering           = optional(bool, false)
    peer_complete_vnets                = optional(bool, true)
    local_peered_address_spaces = optional(list(object({
      address_prefix = string
    })))
    remote_peered_address_spaces = optional(list(object({
      address_prefix = string
    })))
    local_peered_subnets = optional(list(object({
      subnet_name = string
    })))
    remote_peered_subnets = optional(list(object({
      subnet_name = string
    })))
    use_remote_gateways                   = optional(bool, false)
    create_reverse_peering                = optional(bool, false)
    reverse_name                          = optional(string)
    reverse_allow_forwarded_traffic       = optional(bool, false)
    reverse_allow_gateway_transit         = optional(bool, false)
    reverse_allow_virtual_network_access  = optional(bool, true)
    reverse_do_not_verify_remote_gateways = optional(bool, false)
    reverse_enable_only_ipv6_peering      = optional(bool, false)
    reverse_peer_complete_vnets           = optional(bool, true)
    reverse_local_peered_address_spaces = optional(list(object({
      address_prefix = string
    })))
    reverse_remote_peered_address_spaces = optional(list(object({
      address_prefix = string
    })))
    reverse_local_peered_subnets = optional(list(object({
      subnet_name = string
    })))
    reverse_remote_peered_subnets = optional(list(object({
      subnet_name = string
    })))
    reverse_use_remote_gateways        = optional(bool, false)
    sync_remote_address_space_enabled  = optional(bool, false)
    sync_remote_address_space_triggers = optional(any, null)
    timeouts = optional(object({
      create = optional(string, "30m")
      read   = optional(string, "5m")
      update = optional(string, "30m")
      delete = optional(string, "30m")
    }), {})
    retry = optional(object({
      error_message_regex  = optional(list(string), ["ReferencedResourceNotProvisioned"])
      interval_seconds     = optional(number, 10)
      max_interval_seconds = optional(number, 180)
    }), {})
  }))
  default  = {}
  nullable = false
}

variable "retry" {
  description = "Retry configuration for virtual network resource operations."
  type = object({
    error_message_regex  = optional(list(string), ["ReferencedResourceNotProvisioned"])
    interval_seconds     = optional(number, 10)
    max_interval_seconds = optional(number, 180)
  })
  default = {}
}

variable "role_assignments" {
  description = "Role assignments to create on the virtual network."
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
  default  = {}
  nullable = false
}

variable "subnets" {
  description = "Subnets to create, including addressing, associations, delegation, policies, retries, timeouts, and role assignments."
  type = map(object({
    address_prefix   = optional(string)
    address_prefixes = optional(list(string))
    name             = string
    ipam_pools = optional(list(object({
      pool_id                = string
      number_of_ip_addresses = optional(string)
      prefix_length          = optional(number)
      allocation_type        = optional(string, "Static")
    })))
    ignore_body_changes = optional(list(string), [])
    nat_gateway = optional(object({
      id = string
    }))
    network_security_group = optional(object({
      id = string
    }))
    private_endpoint_network_policies             = optional(string, "Enabled")
    private_endpoint_network_policies_enabled     = optional(bool, true)
    private_link_service_network_policies_enabled = optional(bool, true)
    route_table = optional(object({
      id = string
    }))
    service_endpoint_policies = optional(map(object({
      id = string
    })))
    service_endpoints               = optional(set(string))
    default_outbound_access_enabled = optional(bool, false)
    sharing_scope                   = optional(string, null)
    service_endpoints_with_location = optional(list(object({
      service   = string
      locations = optional(list(string), ["*"])
    })))
    delegations = optional(list(object({
      name = string
      service_delegation = object({
        name = string
      })
    })))
    timeouts = optional(object({
      create = optional(string, "30m")
      read   = optional(string, "5m")
      update = optional(string, "30m")
      delete = optional(string, "30m")
    }), {})
    retry = optional(object({
      error_message_regex  = optional(list(string), ["ReferencedResourceNotProvisioned"])
      interval_seconds     = optional(number, 10)
      max_interval_seconds = optional(number, 180)
    }), {})
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    })))
  }))
  default  = {}
  nullable = false
}

variable "tags" {
  description = "Tags applied to the virtual network."
  type        = map(string)
  default     = null
}

variable "timeouts" {
  description = "Timeouts for virtual network resource operations."
  type = object({
    create = optional(string, "30m")
    read   = optional(string, "5m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {}
}
