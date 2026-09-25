locals {
  inbound_subnet_name       = "snet-dnsr-inbound-${var.test_run_id}"
  outbound_subnet_name      = "snet-dnsr-outbound-${var.test_run_id}"
  private_dns_resolver_name = "dnspr-module-test-${var.test_run_id}"
  resource_group_name       = "rg-dnsr-module-test-${var.test_run_id}"
  virtual_network_name      = "vnet-dnsr-test-${var.test_run_id}"

  # Private DNS Resolver requires dedicated subnets delegated to the service.
  resolver_delegation = [{
    name = "Microsoft.Network.dnsResolvers"
    service_delegation = {
      name = "Microsoft.Network/dnsResolvers"
    }
  }]

  # Azure removes the dnsResolverLink service association link asynchronously,
  # so subnet deletion is rejected until that cleanup completes.
  resolver_subnet_retry = {
    error_message_regex = ["ReferencedResourceNotProvisioned", "InUseSubnetCannotBeDeleted"]
  }

  # Bounds the retry loop above so a stuck link fails the run instead of hanging.
  resolver_subnet_timeouts = {
    delete = "10m"
  }
}

module "resource_group" {
  source = "../../resource-group"

  name     = local.resource_group_name
  location = var.location
  tags     = var.tags
}

module "virtual_network" {
  source = "../../virtual-network"

  name          = local.virtual_network_name
  location      = module.resource_group.location
  parent_id     = module.resource_group.id
  address_space = var.address_space
  subnets = {
    inbound = {
      name             = local.inbound_subnet_name
      address_prefixes = [cidrsubnet(var.address_space[0], 12, 0)]
      delegations      = local.resolver_delegation
      retry            = local.resolver_subnet_retry
      timeouts         = local.resolver_subnet_timeouts
    }
    outbound = {
      name             = local.outbound_subnet_name
      address_prefixes = [cidrsubnet(var.address_space[0], 12, 1)]
      delegations      = local.resolver_delegation
      retry            = local.resolver_subnet_retry
      timeouts         = local.resolver_subnet_timeouts
    }
  }
  tags = var.tags
}

# Sits between the virtual network and the resolver so that on destroy the delay
# elapses after the resolver is gone but before the subnets are deleted.
resource "time_sleep" "resolver_teardown" {
  depends_on = [module.virtual_network]

  destroy_duration = var.resolver_teardown_delay
}

module "private_dns_resolver" {
  source = "./.."

  depends_on = [time_sleep.resolver_teardown]

  name                        = local.private_dns_resolver_name
  location                    = module.resource_group.location
  resource_group_name         = module.resource_group.name
  virtual_network_resource_id = module.virtual_network.id
  enable_telemetry            = false
  inbound_endpoints = {
    inbound = {
      name        = "in-${local.private_dns_resolver_name}"
      subnet_name = local.inbound_subnet_name
    }
  }
  outbound_endpoints = {
    outbound = {
      name        = "out-${local.private_dns_resolver_name}"
      subnet_name = local.outbound_subnet_name
      forwarding_ruleset = {
        default = {
          name = "dnsfrs-${var.test_run_id}"
          rules = {
            forwarded = {
              name                     = "rule-forwarded"
              domain_name              = var.forwarding_rule_domain_name
              destination_ip_addresses = var.forwarding_rule_destination_ip_addresses
            }
          }
        }
      }
    }
  }
  tags = var.tags
}
