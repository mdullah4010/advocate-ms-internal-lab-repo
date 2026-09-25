output "name" {
  description = "The route table name"
  value       = module.this.name
}

output "resource" {
  description = "This is the full output for the route table."
  value       = module.this.resource
}

output "resource_id" {
  description = "The ID of the route table"
  value       = module.this.resource_id
}

output "routes" {
  description = "This is the full output of the routes."
  value       = module.this.routes
}