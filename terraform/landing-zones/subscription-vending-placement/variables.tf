variable "tenant_id" {
  description = "Microsoft Entra tenant ID."
  type        = string
}

variable "deployment_subscription_id" {
  description = "Subscription used to configure the AzureRM provider."
  type        = string
}

variable "vended_subscriptions" {
  description = "New subscriptions keyed by a stable semantic name."
  type = map(object({
    subscription_name   = string
    alias               = optional(string)
    billing_scope_id    = string
    workload            = optional(string, "Production")
    management_group_id = string
    tags                = optional(map(string), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for subscription in values(var.vended_subscriptions) :
      contains(["Production", "DevTest"], subscription.workload)
    ])
    error_message = "Subscription workload must be Production or DevTest."
  }
}

variable "existing_subscription_placements" {
  description = "Existing subscriptions to place or move. Only explicitly authorized entries are managed."
  type = map(object({
    subscription_id     = string
    management_group_id = string
    move_authorized     = bool
  }))
  default = {}
}
