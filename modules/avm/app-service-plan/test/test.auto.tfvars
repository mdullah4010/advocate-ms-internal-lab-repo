location        = "westus3"
test_run_id     = "local-001"

os_type               = "Linux"
async_scaling_enabled = false

managed_identities = {
  system_assigned = true
}

maximum_elastic_worker_count    = 3
per_site_scaling_enabled        = false
premium_plan_auto_scale_enabled = true

server_farm_resource_type = "Microsoft.Web/serverfarms@2025-03-01"
sku_name                  = "P1v2"

tags = {
  environment = "test"
  managedBy   = "terraform"
  purpose     = "app-service-plan-module-test"
}

worker_count           = 3
zone_balancing_enabled = true
