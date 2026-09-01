# Advocate Azure Landing Zone IaC

Customer deployment repository containing Terraform code for:

- the Advocate management-group hierarchy and management-group RBAC;
- subscription vending and explicitly authorized subscription placement;
- GitHub Actions validation, plan, and protected apply with Azure OIDC.

## Deployment roots

- `terraform/landing-zones/management-groups`
- `terraform/landing-zones/rbac`
- `terraform/landing-zones/subscription-vending-placement`

Copy the applicable `.tfvars.example` and `backend.hcl.example` files to ignored local files, replace example values, and use the GitHub workflows for deployment.

Existing subscription movement is disabled unless its input sets `move_authorized = true`.

Deploy the landing-zone components in this order: management groups, RBAC, then subscription vending and placement.
