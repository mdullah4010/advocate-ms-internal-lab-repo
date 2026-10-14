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

variable "test_run_id" {
  description = "Unique identifier appended to temporary resource names."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.test_run_id))
    error_message = "Test run ID may contain only letters, numbers, and hyphens."
  }
}

variable "address_space" {
  description = "Address space for the private DNS test virtual network."
  type        = list(string)
  default     = ["10.253.0.0/16"]

  validation {
    condition     = length(var.address_space) > 0 && alltrue([for address in var.address_space : can(cidrnetmask(address))])
    error_message = "At least one valid CIDR address prefix must be provided."
  }
}

variable "domain_name" {
  description = "Domain name for the test private DNS zone."
  type        = string
  default     = "privatelink.blob.core.windows.net"
}

variable "parent_id" {
  description = "Optional parent resource ID. When null, the fixture resource group ID is used."
  type        = string
  default     = null
}

variable "a_records" {
  description = "A records for the test private DNS zone."
  type = map(object({
    name         = string
    ttl          = number
    records      = optional(list(string))
    ip_addresses = optional(set(string), null)
  }))
  default = {}
}

variable "aaaa_records" {
  description = "AAAA records for the test private DNS zone."
  type = map(object({
    name         = string
    ttl          = number
    records      = optional(list(string))
    ip_addresses = optional(set(string), null)
  }))
  default = {}
}

variable "cname_records" {
  description = "CNAME records for the test private DNS zone."
  type = map(object({
    name   = string
    ttl    = number
    record = optional(string, null)
    cname  = optional(string, null)
  }))
  default = {}
}

variable "enable_telemetry" {
  description = "Whether telemetry is enabled for the test private DNS zone."
  type        = bool
  default     = false
}

variable "lock" {
  description = "Optional management lock for the test private DNS zone."
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null
}

variable "mx_records" {
  description = "MX records for the test private DNS zone."
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
  description = "PTR records for the test private DNS zone."
  type = map(object({
    name         = string
    ttl          = number
    records      = optional(list(string), null)
    domain_names = optional(set(string), null)
  }))
  default = {}
}

variable "retry" {
  description = "Retry configuration for test private DNS zone operations."
  type = object({
    error_message_regex  = optional(list(string), ["ReferencedResourceNotProvisioned", "CannotDeleteResource"])
    interval_seconds     = optional(number, 10)
    max_interval_seconds = optional(number, 180)
    multiplier           = optional(number, 1.5)
    randomization_factor = optional(number, 0.5)
  })
  default = {}
}

variable "role_assignment_name_use_random_uuid" {
  description = "Whether role assignments use random UUID names."
  type        = bool
  default     = true
}

variable "role_assignments" {
  description = "Role assignments for the test private DNS zone."
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
  description = "SOA record for the test private DNS zone."
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
  description = "SRV records for the test private DNS zone."
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

variable "timeouts" {
  description = "Timeouts for test private DNS zone operations."
  type = object({
    dns_zones = optional(object({
      create = optional(string, "30m")
      delete = optional(string, "30m")
      update = optional(string, "30m")
      read   = optional(string, "5m")
    }), {})
    vnet_links = optional(object({
      create = optional(string, "30m")
      delete = optional(string, "30m")
      update = optional(string, "30m")
      read   = optional(string, "5m")
    }), {})
  })
  default = {}
}

variable "txt_records" {
  description = "TXT records for the test private DNS zone."
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
  description = "Virtual network links. The fixture supplies its VNet ID when both supported ID fields are null."
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

variable "tags" {
  description = "Tags applied to the temporary test resources."
  type        = map(string)
  default = {
    environment = "test"
    managedBy   = "terraform"
    purpose     = "private-dns-zones-module-test"
  }
}