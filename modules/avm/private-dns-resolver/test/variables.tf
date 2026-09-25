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
  description = "Address space for the private DNS resolver test virtual network."
  type        = list(string)
  default     = ["10.254.0.0/16"]

  validation {
    condition     = length(var.address_space) > 0 && alltrue([for address in var.address_space : can(cidrnetmask(address))])
    error_message = "At least one valid CIDR address prefix must be provided."
  }
}

variable "forwarding_rule_domain_name" {
  description = "Domain name forwarded by the test forwarding rule. Must be fully qualified with a trailing dot."
  type        = string
  default     = "contoso.com."

  validation {
    condition     = endswith(var.forwarding_rule_domain_name, ".")
    error_message = "Domain name must be fully qualified and end with a trailing dot."
  }
}

variable "forwarding_rule_destination_ip_addresses" {
  description = "Destination DNS servers for the test forwarding rule, keyed by IP address with the port as the value."
  type        = map(string)
  default = {
    "10.10.0.4" = "53"
  }

  validation {
    condition     = length(var.forwarding_rule_destination_ip_addresses) > 0
    error_message = "At least one destination DNS server must be provided."
  }

  validation {
    condition     = alltrue([for ip in keys(var.forwarding_rule_destination_ip_addresses) : can(cidrhost("${ip}/32", 0))])
    error_message = "Each destination key must be a valid IPv4 address."
  }
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
