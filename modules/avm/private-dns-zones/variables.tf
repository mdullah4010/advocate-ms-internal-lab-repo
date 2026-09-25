variable "domain_name" {
  description = "The domain name for the private DNS zones."
  type        = string
}

variable "parent_id" {
  description = "The resource ID of the resource group that will contain the private DNS zones."
  type        = string
}

variable "a_records" {
  description = "Controls whether an A record is created for the private DNS zones."
  type        = map(object({
    name         = string
    ttl          = number
    records      = optional(list(string))
    ip_addresses = optional(set(string), null)
  }))
  default     = {}
}

variable "aaaa_records" {
  description = "Controls whether an AAAA record is created for the private DNS zones."
  type = map(object({
    name         = string
    ttl          = number
    records      = optional(list(string))
    ip_addresses = optional(set(string), null)
  }))
  default     = {}
}

variable "cname_records" {
  description = "Controls whether a CNAME record is created for the private DNS zones."
  type        = map(object({
    name   = string
    ttl    = number
    record = optional(string, null)
    cname  = optional(string, null)
  }))
  default     = {}
}

variable "enable_telemetry" {
  description = "Controls whether telemetry is enabled for the private DNS zones."
  type = bool
  default = true
}

variable "lock" {
  description = "Controls the Resource Lock configuration for this resource."
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null
}

variable "mx_records" {
  description = "Map of objects where each object contains information to create a MX record."
  type = map(object({
    name = optional(string, "@")
    ttl  = number
    records = map(object({
      preference = number
      exchange   = string
    }))
  }))
  default = {}
}

variable "ptr_records" {
  description = "Controls whether a PTR record is created for the private DNS zones."
  type = map(object({
    name         = string
    ttl          = number
    records      = optional(list(string), null)
    domain_names = optional(set(string), null)
  }))
  default = {}
}

variable "retry" {
  description = "Retry configuration for the resource operations."
  type        = object({
    error_message_regex  = optional(list(string), ["ReferencedResourceNotProvisioned", "CannotDeleteResource"])
    interval_seconds     = optional(number, 10)
    max_interval_seconds = optional(number, 180)
    multiplier           = optional(number, 1.5)
    randomization_factor = optional(number, 0.5)
  })
  default     = {}
}

variable "role_assignment_name_use_random_uuid" {
  description = "Controls whether role assignments use a random UUID for their names."
  type = bool
  default = true
}

variable "role_assignments" {
  description = "Role assignments configuration for the resource operations."
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

variable "soa_record" {
  description = "SOA record configuration for the private DNS zones."
  type = object({
    email        = string
    name         = optional(string, "@")
    expire_time  = optional(number, 2419200)
    minimum_ttl  = optional(number, 10)
    refresh_time = optional(number, 3600)
    retry_time   = optional(number, 300)
    ttl          = optional(number, 3600)
  })
  default = null
}

variable "srv_records" {
  description = "SRV record configuration for the private DNS zones."
  type = map(object({
    name = string
    ttl  = number
    records = map(object({
      priority = number
      weight   = number
      port     = number
      target   = string
    }))
  }))
  default = {}
}

variable "tags" {
  description = "Tags template for the private DNS zones."
  type        = map(string)
  default     = null
}

variable "timeouts" {
  description = "map of timeouts objects, per resource type, to apply to the creation and destruction of resources."
  type = object({
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
  default = {
    dns_zones = {
      create = "30m"
      delete = "30m"
      read   = "5m"
      update = "30m"
    }
    vnet_links = {
      create = "30m"
      delete = "30m"
      read   = "5m"
      update = "30m"
    }
  }
}
variable "txt_records" {
  description = "TXT record configuration for the private DNS zones."
  type = map(object({
    name = string
    ttl  = number
    records = map(object({
      value = list(string)
    }))
  }))
  default = {}
}

variable "virtual_network_links" {
  description = "Virtual network link where each object contains information to create a virtual network link."
  type = map(object({
    vnetlinkname                           = optional(string, null)
    name                                   = optional(string, null)
    vnetid                                 = optional(string, null)
    virtual_network_id                     = optional(string, null)
    autoregistration                       = optional(bool, false)
    registration_enabled                   = optional(bool, null)
    private_dns_zone_supports_private_link = optional(bool, false)
    resolution_policy                      = optional(string, "Default")
    tags                                   = optional(map(string), null)
  }))
  default = {}
}