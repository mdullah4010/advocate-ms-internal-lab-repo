# Advocate Azure Landing Zone IaC

Terraform automation for the Advocate management-group hierarchy, management-group RBAC, and subscription vending and placement.

## Repository structure

- `.github/`: GitHub Actions and ownership rules.
- `.pipelines/`: reserved for additional deployment pipelines.
- `azure/`: reserved for Azure platform configuration outside the current Terraform roots.
- `docs/`: architecture and operational documentation.
- `envs/prod/`: production Terraform deployment roots.
- `envs/test/`: test deployment-root placeholders.
- `modules/`: reusable Terraform modules.
- `scripts/`: automation and validation scripts.

## Deployment order

1. `envs/prod/management-groups`
2. `envs/prod/rbac`
3. `envs/prod/subscription-vending-placement`

Copy the applicable variable and backend examples, replace placeholders, and use the GitHub workflows. Existing subscription movement remains disabled unless `move_authorized` is explicitly set to `true`.
