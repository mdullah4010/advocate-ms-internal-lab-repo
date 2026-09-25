output "forwarding_rulesets" {
  description = "The forwarding rulesets of the private DNS resolver."
  value       = module.this.forwarding_rulesets
}

output "inbound_endpoint_ips" {
  description = "The inbound endpoint IPs of the private DNS resolver."
  value       = module.this.inbound_endpoint_ips
}

output "inbound_endpoints" {
  description = "The inbound endpoints of the private DNS resolver."
  value       = module.this.inbound_endpoints
}

output "name" {
  description = "The name of the private DNS resolver."
  value       = module.this.name
}

output "outbound_endpoints" {
  description = "The outbound endpoints of the private DNS resolver."
  value       = module.this.outbound_endpoints
}

output "resource" {
  description = "The resource of the private DNS resolver."
  value       = module.this.resource
}

output "resource_id" {
  description = "The resource ID of the private DNS resolver."
  value       = module.this.resource_id
}