variable "location" {
  description = "Azure region where the private endpoint is deployed."
  type        = string
  nullable    = false
}

variable "name" {
  description = "Enterprise-generated name of the private endpoint."
  type        = string
  nullable    = false

  validation {
    condition = (
      length(var.name) >= 2 &&
      length(var.name) <= 64 &&
      can(regex("^[A-Za-z0-9](?:[A-Za-z0-9._-]{0,62}[A-Za-z0-9_])?$", var.name))
    )
    error_message = "Private endpoint name must be 2-64 characters, begin with an alphanumeric character, and end with an alphanumeric character or underscore."
  }
}

variable "network_interface_name" {
  description = "Custom name of the network interface attached to the private endpoint. Changing this value replaces the resource."
  type        = string
}

variable "private_connection_resource_id" {
  description = "Resource ID of the Private Link-enabled resource to which the private endpoint connects."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group where the private endpoint is deployed."
  type        = string
}

variable "subnet_resource_id" {
  description = "Resource ID of the subnet from which private IP addresses are allocated. Changing this value replaces the resource."
  type        = string
}

variable "application_security_group_association_ids" {
  description = "Resource IDs of application security groups to associate with the private endpoint."
  type        = set(string)
  default     = []
}

variable "enable_telemetry" {
  description = "Controls whether telemetry is enabled for the module."
  type        = bool
  default     = true
}

variable "ip_configurations" {
  description = "Static IP configurations for the private endpoint."
  type = map(object({
    name               = string
    private_ip_address = string
    subresource_name   = string
    member_name        = optional(string, "default")
  }))
  default = {}
}

variable "lock" {
  description = "Resource lock configuration for the private endpoint."
  type = object({
    name = optional(string, null)
    kind = string
  })
  default = null

  validation {
    condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly", "None"], var.lock.kind) : true
    error_message = "The lock level must be one of: 'None', 'CanNotDelete', or 'ReadOnly'."
  }
}

variable "private_dns_zone_group_name" {
  description = "Name of the private DNS zone group."
  type        = string
  default     = null
}

variable "private_dns_zone_resource_ids" {
  description = "Resource IDs of the private DNS zones included in the private DNS zone group."
  type        = list(string)
  default     = []
}

variable "private_service_connection_name" {
  description = "Name of the private service connection."
  type        = string
  default     = null
}

variable "role_assignments" {
  description = "Role assignments to create on the private endpoint."
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

variable "subresource_names" {
  description = "Subresource names on the Private Link-enabled resource to which the private endpoint connects."
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Mandatory and additional tags applied to the private endpoint."
  type        = map(string)
  nullable    = false

  validation {
    condition     = length(var.tags) > 0
    error_message = "At least one tag must be provided."
  }
}
