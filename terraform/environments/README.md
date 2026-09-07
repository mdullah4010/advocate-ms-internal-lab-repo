# Environment configuration

Each environment has one variable file per deployment stack. Copy the provided examples to files without the `.example` suffix and replace all placeholders before running a deployment.

Expected paths:

- `test/management-groups.tfvars`
- `test/rbac.tfvars`
- `test/subscription-vending-placement.tfvars`
- `test/connectivity.tfvars`
- `prod/management-groups.tfvars`
- `prod/rbac.tfvars`
- `prod/subscription-vending-placement.tfvars`

These files should contain non-secret identifiers and desired configuration only. GitHub environment variables provide identity and backend settings.

Tenant and deployment subscription IDs are intentionally omitted from these files. The deployment workflow maps `AZURE_TENANT_ID` and `AZURE_SUBSCRIPTION_ID` to Terraform's `TF_VAR_tenant_id`, `TF_VAR_subscription_id`, and `TF_VAR_deployment_subscription_id` environment variables. Terraform automatically uses a `TF_VAR_<variable-name>` value when the selected tfvars file does not define that input.

For local execution, set the matching `TF_VAR_` environment variables in the shell or add the values only to an ignored local variable file.
