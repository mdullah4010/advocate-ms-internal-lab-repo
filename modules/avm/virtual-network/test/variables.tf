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

variable "parent_id" {
  description = "Optional parent resource ID. When null, the fixture resource group ID is used."
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
  description = "CIDR address spaces assigned to the primary test virtual network."
  type        = list(string)
  default     = ["10.250.0.0/16"]

  validation {
    condition     = length(var.address_space) > 0 && alltrue([for cidr in var.address_space : can(cidrhost(cidr, 0))])
    error_message = "Provide at least one valid CIDR address space for the primary virtual network."
  }
}

variable "bgp_community" {
  description = "Optional BGP community for the primary test virtual network."
  type        = string
  default     = null
}

variable "ddos_protection_plan" {
  description = "Optional DDoS protection plan for the primary test virtual network."
  type = object({
    id     = string
    enable = bool
  })
  default = null
}

variable "diagnostic_settings" {
  description = "Diagnostic settings for the primary test virtual network."
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
  default = {}
}

variable "peer_address_space" {
  description = "CIDR address spaces assigned to the secondary peered test virtual network."
  type        = list(string)
  default     = ["10.251.0.0/16"]

  validation {
    condition     = length(var.peer_address_space) > 0 && alltrue([for cidr in var.peer_address_space : can(cidrhost(cidr, 0))])
    error_message = "Provide at least one valid CIDR address space for the secondary virtual network."
  }
}

variable "dns_servers" {
  description = "Optional custom DNS server configuration."
  type = object({
    dns_servers = list(string)
  })
  default = null
}

variable "enable_telemetry" {
  description = "Whether telemetry is enabled for the primary test virtual network."
  type        = bool
  default     = false
}

variable "enable_vm_protection" {
  description = "Whether VM protection is enabled for the primary test virtual network."
  type        = bool
  default     = false
}

variable "encryption" {
  description = "Optional encryption settings for the primary test virtual network."
  type = object({
    enabled     = bool
    enforcement = string
  })
  default = null
}

variable "extended_location" {
  description = "Optional extended location for the primary test virtual network."
  type = object({
    name = string
    type = string
  })
  default = null
}

variable "flow_timeout_in_minutes" {
  description = "Optional flow timeout for the primary test virtual network."
  type        = number
  default     = null
}

variable "ignore_body_changes" {
  description = "AzAPI body paths ignored by the primary test virtual network."
  type = object({
    virtual_networks = optional(list(string), [])
    virtual_networks_subnets = optional(object({
      virtual_networks_subnets = optional(list(string), [])
    }), {})
    virtual_networks_virtual_network_peerings = optional(object({
      virtual_networks_virtual_network_peerings = optional(list(string), [])
    }), {})
  })
  default = {}
}

variable "ipam_pools" {
  description = "Optional IPAM pools for the primary test virtual network."
  type = list(object({
    id                     = string
    number_of_ip_addresses = optional(string)
    prefix_length          = optional(number)
  }))
  default = null
}

variable "lock" {
  description = "Optional management lock for the primary test virtual network."
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null
}

variable "name" {
  description = "Name of the primary test virtual network."
  type        = string
  default     = "vnet-primary-test"
}

variable "peerings" {
  description = "Peerings for the primary test virtual network. The fixture supplies a remote VNet ID when one is null."
  type = map(object({
    name                               = string
    remote_virtual_network_resource_id = optional(string, null)
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
  default = {}
}

variable "retry" {
  description = "Retry configuration for primary virtual network operations."
  type = object({
    error_message_regex  = optional(list(string), ["ReferencedResourceNotProvisioned"])
    interval_seconds     = optional(number, 10)
    max_interval_seconds = optional(number, 180)
  })
  default = {}
}

variable "role_assignments" {
  description = "Role assignments for the primary test virtual network."
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

variable "subnets" {
  description = "Subnets for the primary test virtual network."
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
  default = {}
}

variable "timeouts" {
  description = "Timeouts for primary virtual network operations."
  type = object({
    create = optional(string, "30m")
    read   = optional(string, "5m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {}
}

variable "tags" {
  description = "Tags applied to the temporary test resources."
  type        = map(string)
  default = {
    environment = "test"
    managedBy   = "terraform"
    purpose     = "virtual-network-module-test"
  }
}
