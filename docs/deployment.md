# Deployment and maintenance

Create and secure the Azure Storage state infrastructure by following [terraform-remote-backend.md](terraform-remote-backend.md) before initializing a deployment root.

## Prerequisites

- Terraform `1.9.x`.
- An Azure Storage account and private blob container for Terraform state.
- Microsoft Entra applications or user-assigned managed identities for plan and apply.
- Federated credentials for each GitHub environment used by the workflows.
- Azure permissions appropriate to each stack and `Storage Blob Data Contributor` on the state container.

The state account should disable public blob access and shared-key authorization, require TLS 1.2 or newer, enable blob versioning and soft delete, and restrict its network endpoint. When the endpoint is private, use the self-hosted runner described in [self-hosted-runner.md](self-hosted-runner.md).

## GitHub environments and OIDC

Create these GitHub environments:

- `test-plan` and `test-apply`
- `prod-plan` and `prod-apply`

Require reviewers on both apply environments, especially `prod-apply`. Configure each Azure federated identity credential with:

- issuer: `https://token.actions.githubusercontent.com`
- audience: `api://AzureADTokenExchange`
- subject: `repo:<organization>/<repository>:environment:<github-environment>`

Configure the following GitHub environment variables. Values may differ by environment:

| Variable | Description |
| --- | --- |
| `AZURE_PLAN_CLIENT_ID` | Client ID used by the plan job. |
| `AZURE_APPLY_CLIENT_ID` | Client ID used by the apply job. |
| `AZURE_TENANT_ID` | Microsoft Entra tenant ID. |
| `AZURE_SUBSCRIPTION_ID` | Provider deployment subscription ID. |
| `TFSTATE_RESOURCE_GROUP` | State storage resource group. |
| `TFSTATE_STORAGE_ACCOUNT` | State storage account name. |
| `TFSTATE_CONTAINER` | State blob container name. |
| `TFSTATE_SUBSCRIPTION_ID` | Subscription containing state storage. |

OIDC requires no GitHub client secret. Keep plan and apply identities separate. Grant the plan identity read-only access wherever practical and grant the apply identity only the roles required by the selected stack.

The workflow also exposes `AZURE_TENANT_ID` and `AZURE_SUBSCRIPTION_ID` to Terraform as `TF_VAR_tenant_id`, `TF_VAR_subscription_id`, and `TF_VAR_deployment_subscription_id`. The connectivity stack consumes `subscription_id`; the other deployment roots consume `deployment_subscription_id`. These identity values therefore do not need to be duplicated in environment tfvars files.

## Environment configuration

Copy each file ending in `.tfvars.example` under `terraform/environments/<environment>` to the same name without `.example`, then replace every placeholder. Commit only reviewed, non-secret values. Never place passwords, tokens, certificates, or access keys in a tfvars file.

The workflow resolves configuration from this fixed path:

`terraform/environments/<environment>/<stack>.tfvars`

This prevents a workflow dispatch from selecting an unrelated repository file. Existing subscription movement remains opt-in per entry with `move_authorized = true`.

## Pull-request validation

The **Terraform Validate** workflow checks formatting, initializes without accessing remote state, and validates all deployment roots. Branch protection should require this workflow and CODEOWNERS approval before merging.

For equivalent local validation, run formatting from the repository root, then initialize each deployment root with `-backend=false` and run `terraform validate`.

## Plan and apply

1. Open **Actions** and select **Terraform Plan and Apply**.
2. Select the stack and environment.
3. Leave **apply** disabled to create and inspect a plan-only run.
4. To deploy, start a new run with **apply** enabled. The apply job downloads and applies the exact saved plan produced by its required plan job.
5. Approve the protected apply environment when prompted.

State keys are isolated by environment and stack at `advocate/<environment>/<stack>.tfstate`. Workflow concurrency prevents two runs from changing the same state simultaneously.

## Local initialization

Copy a stack's `backend.hcl.example` to `backend.hcl`, set the state values, and initialize with `terraform init -backend-config=backend.hcl`. Authenticate with Azure CLI or workload identity; do not use storage account keys. Local backend files, state, plans, and root-level local tfvars files are ignored by Git.

## Maintenance and recovery

- Update provider constraints deliberately and commit lock-file changes after validation.
- Review plans for destructive management-group moves, role removals, and subscription placement changes.
- Never edit state blobs directly. Use Terraform state commands only after taking a versioned backup.
- Recover an accidentally changed or deleted state blob from Azure Storage blob versions or soft delete.
- Rotate federated identities by adding the replacement credential, updating GitHub variables, validating a plan, and then removing the old credential.
- Remove expired workflow artifacts and retain state according to the platform retention policy.
