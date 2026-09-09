<<<<<<< HEAD
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
=======
# Advocate Azure Landing Zone

Terraform and GitHub Actions automation for the Advocate Azure Landing Zone.

## Components

| Stack | Purpose |
| --- | --- |
| `management-groups` | Creates the governed management-group hierarchy. |
| `rbac` | Applies management-group role assignments. |
| `subscription-vending-placement` | Vends subscriptions and performs explicitly authorized placements. |
| `connectivity` | Deploys the initial internal-subscription hub virtual network. |

Reusable Terraform modules are under `terraform/modules`. Environment configuration is under `terraform/environments`.

## Deployment order

1. `management-groups`
2. `rbac`
3. `subscription-vending-placement`

Pull requests run formatting and validation for every stack. Deployments are manually started with the **Terraform Plan and Apply** workflow and use GitHub-to-Azure OIDC; no client secret is required. Production apply should be protected with required reviewers in the GitHub `prod-apply` environment.

See [docs/deployment.md](docs/deployment.md) for deployment and maintenance procedures, [docs/terraform-remote-backend.md](docs/terraform-remote-backend.md) for creating the Azure Storage remote backend, and [docs/self-hosted-runner.md](docs/self-hosted-runner.md) for configuring private-network workflow execution.
>>>>>>> 1b8411a09455220f9b700b9252501e425ea28aa3
