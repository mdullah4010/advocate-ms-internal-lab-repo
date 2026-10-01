# Terraform bootstrap deployment

The **Deploy Terraform Bootstrap** GitHub Actions workflow proves that GitHub can authenticate to Azure with OpenID Connect (OIDC), run Terraform, and create a resource group in the target subscription.

Deployment is automatic: merging or pushing a change to `main` deploys it. No one needs to start the workflow by hand.

## One-time Azure and GitHub setup

Create a Microsoft Entra application or user-assigned managed identity with:

- a federated credential for this GitHub repository;
- permission to create resource groups in the target subscription, such as `Contributor` scoped to the subscription.

Configure these GitHub Actions repository secrets:

| Secret | Description |
| --- | --- |
| `AZURE_CLIENT_ID` | Client ID of the federated application or managed identity. |
| `AZURE_TENANT_ID` | Microsoft Entra tenant ID. |
| `AZURE_SUBSCRIPTION_ID` | Subscription in which the resource group will be created. |

The federated credential uses:

- issuer: `https://token.actions.githubusercontent.com`
- audience: `api://AzureADTokenExchange`
- subject: `repo:<organization>/<repository>:ref:refs/heads/main`

## Automatic deployment

The workflow runs automatically when a commit that changes `bootstrap/**` or `.github/workflows/deploy-bootstrap.yml` reaches `main`. Merging the workflow itself therefore triggers the first deployment.

Each run executes `terraform fmt`, `terraform init`, `terraform validate`, `terraform plan`, and `terraform apply`, then verifies the resource group with Azure CLI. The result is shown in the run's job summary.

To redeploy without a code change, for example after correcting a secret, select **Run workflow** on the workflow's **Actions** page.

## Deployed resource

| Setting | Value |
| --- | --- |
| Region | `eastus2` by default |
| Resource group | `rg-advocate-internal-bootstrap-<region>`, for example `rg-advocate-internal-bootstrap-eastus2` |

Automatic runs use `eastus2`. To deploy to another region, select **Run workflow** and enter its region name, such as `eastus`. Because the region is part of the name, this creates a separate resource group instead of replacing the existing one. To change the default region, replace `eastus2` in the workflow.

## Terraform state

This proof of concept uses Terraform local state, which is discarded when each run ends. So that reruns update the resource group instead of failing because it already exists, the workflow imports the existing resource group into state before planning.

Because state is not retained between runs, Terraform does not delete resources that are renamed or removed from the configuration; delete those manually. Add an Azure Storage remote backend before using this workflow for additional Landing Zone components.

## Logs

Terraform init, validate, import, plan, apply, and verification output, plus the rendered plan, are uploaded as the `terraform-bootstrap-logs-<run-id>-<attempt>` artifact and retained for 30 days. GitHub retains the native job logs according to the repository or organization Actions retention setting.

## Cleanup

To remove the proof-of-concept resource group:

```bash
az group delete --name rg-advocate-internal-bootstrap-eastus2 --yes
```

Replace `eastus2` for other regions. The next automatic run recreates the default resource group.
