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
