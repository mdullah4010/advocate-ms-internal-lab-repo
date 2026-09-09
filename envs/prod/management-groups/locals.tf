locals {
  platform_children = {
    management          = "Management"
    connectivity        = "Connectivity"
    identity            = "Identity"
    security-operations = "Security Operations"
  }

  workload_categories = {
    clinical-systems        = "Clinical Systems"
    enterprise-applications = "Enterprise Applications"
    data-analytics          = "Data & Analytics"
    research                = "Research"
    collaboration-services  = "Collaboration Services"
  }

  consolidation_children = {
    wake-tenant    = "Wake Tenant"
    midwest-tenant = "Midwest Tenant"
  }

  consolidation_environments = merge([
    for tenant in keys(local.consolidation_children) : {
      for environment, display_name in {
        production     = "Production"
        non-production = "Non-Production"
        } : "${tenant}-${environment}" => {
        tenant       = tenant
        display_name = display_name
      }
    }
  ]...)

  management_group_ids = merge(
    {
      advocate       = module.advocate.id
      platform       = module.top_level["platform"].id
      workloads      = module.top_level["workloads"].id
      consolidation  = module.top_level["consolidation"].id
      sandbox        = module.top_level["sandbox"].id
      decommissioned = module.top_level["decommissioned"].id
      production     = module.workload_environment["production"].id
      non-production = module.workload_environment["non-production"].id
    },
    { for key, value in module.platform_child : key => value.id },
    { for key, value in module.production_category : "prod-${key}" => value.id },
    { for key, value in module.nonproduction_category : "nonprod-${key}" => value.id },
    { for key, value in module.consolidation_child : key => value.id },
    { for key, value in module.consolidation_environment : key => value.id }
  )
}
