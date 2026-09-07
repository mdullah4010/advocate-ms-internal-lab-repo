# Create the Azure Storage Terraform remote backend

This guide creates an Azure Storage backend for Terraform state using Microsoft Entra authentication. The examples use the `westus3` Azure region.

## Prerequisites

- Azure CLI installed.
- Permission to create a resource group, storage account, container, and role assignments in the state subscription.
- A Microsoft Entra tenant ID and Azure state subscription ID.
- Terraform deployment identities for manual and GitHub Actions executions.
- A workstation or self-hosted GitHub Actions runner connected to the virtual network containing the storage private endpoint, or to a network connected through VPN/ExpressRoute.
- Private DNS resolution for the Azure Blob private endpoint.

Do not use storage account keys. The repository is configured to use Microsoft Entra authentication and GitHub OIDC.

## 1. Sign in and select the state subscription

```powershell
$TenantId            = "<tenant-id>"
$StateSubscriptionId = "<state-subscription-id>"

az login --tenant $TenantId
az account set --subscription $StateSubscriptionId
az account show --output table
```

The state subscription may be separate from the subscription containing the landing-zone resources.

## 2. Define backend values

Storage account names must be globally unique, contain 3–24 lowercase letters and numbers, and contain no hyphens.

```powershell
$Location       = "westus3"
$ResourceGroup  = "rg-advocate-tfstate-westus3"
$StorageAccount = "stadvocatetfstate<unique>"
$Container      = "tfstate"
```

Replace `<unique>` with a short suffix that makes the storage account name globally unique.

## 3. Create the resource group

```powershell
az group create `
  --name $ResourceGroup `
  --location $Location `
  --tags managedBy=terraform purpose=terraform-state environment=shared
```

## 4. Create the storage account

The following settings enforce HTTPS, TLS 1.2, private blobs, and Microsoft Entra authentication instead of storage keys:

```powershell
az storage account create `
  --name $StorageAccount `
  --resource-group $ResourceGroup `
  --location $Location `
  --sku Standard_LRS `
  --kind StorageV2 `
  --https-only true `
  --min-tls-version TLS1_2 `
  --allow-blob-public-access false `
  --allow-shared-key-access false `
  --public-network-access Disabled `
  --tags managedBy=terraform purpose=terraform-state environment=shared
```

Public network access is disabled. Terraform and Azure CLI data-plane operations must reach the account through a Blob private endpoint. A standard GitHub-hosted runner cannot reach a private endpoint; use a self-hosted runner with private network connectivity.

Get the storage account resource ID for the private endpoint and later role assignments:

```powershell
$StorageAccountId = az storage account show `
  --name $StorageAccount `
  --resource-group $ResourceGroup `
  --query id `
  --output tsv
```

## 5. Create a Blob private endpoint and DNS integration

Define the network values. The subnet must already exist and must be reachable from the workstation or self-hosted runner:

```powershell
$NetworkResourceGroup = "<network-resource-group>"
$VirtualNetwork       = "<virtual-network-name>"
$PrivateEndpointSubnet = "<private-endpoint-subnet-name>"
$PrivateEndpointName  = "pe-$StorageAccount-blob"
$PrivateDnsZone       = "privatelink.blob.core.windows.net"
```

Create the private endpoint for the Blob service:

```powershell
az network private-endpoint create `
  --name $PrivateEndpointName `
  --resource-group $ResourceGroup `
  --location $Location `
  --vnet-name $VirtualNetwork `
  --subnet $PrivateEndpointSubnet `
  --private-connection-resource-id $StorageAccountId `
  --group-id blob `
  --connection-name "$PrivateEndpointName-connection"
```

If the virtual network is in a different resource group, use its full resource ID with `--subnet` instead of `--vnet-name` and a subnet name.

Create and link the private DNS zone:

```powershell
az network private-dns zone create `
  --resource-group $NetworkResourceGroup `
  --name $PrivateDnsZone

az network private-dns link vnet create `
  --resource-group $NetworkResourceGroup `
  --zone-name $PrivateDnsZone `
  --name "link-$VirtualNetwork-blob" `
  --virtual-network $VirtualNetwork `
  --registration-enabled false
```

Attach a DNS zone group to the private endpoint:

```powershell
$PrivateDnsZoneId = az network private-dns zone show `
  --resource-group $NetworkResourceGroup `
  --name $PrivateDnsZone `
  --query id `
  --output tsv

az network private-endpoint dns-zone-group create `
  --resource-group $ResourceGroup `
  --endpoint-name $PrivateEndpointName `
  --name default `
  --private-dns-zone $PrivateDnsZoneId `
  --zone-name blob
```

From the connected workstation or runner, verify that the normal storage hostname resolves to a private IP address:

```powershell
Resolve-DnsName "$StorageAccount.blob.core.windows.net"
```

The answer should follow the `privatelink.blob.core.windows.net` alias and return an RFC 1918 private address. Do not continue with Terraform from a host that resolves only a public address or cannot route to the private endpoint.

## 6. Enable state recovery protections

Enable blob versioning, blob soft delete, and container soft delete with 30-day retention:

```powershell
az storage account blob-service-properties update `
  --account-name $StorageAccount `
  --resource-group $ResourceGroup `
  --enable-versioning true `
  --enable-delete-retention true `
  --delete-retention-days 30 `
  --enable-container-delete-retention true `
  --container-delete-retention-days 30
```

The Terraform AzureRM backend automatically uses Azure Blob leases for state locking.

## 7. Grant the current user temporary blob access

The standard Azure `Contributor` role covers the management plane but does not permit reading or writing blob data. Terraform requires data-plane access to create, read, update, and lock its state blob.

Get the signed-in user's object ID and storage account resource ID:

```powershell
$CurrentUserObjectId = az ad signed-in-user show --query id --output tsv
```

Grant `Storage Blob Data Contributor` temporarily at storage-account scope so the user can create the container:

```powershell
az role assignment create `
  --assignee-object-id $CurrentUserObjectId `
  --assignee-principal-type User `
  --role "Storage Blob Data Contributor" `
  --scope $StorageAccountId
```

Role assignment propagation can take several minutes.

## 8. Create the private state container

Create the container through the Azure Resource Manager management plane. This avoids requiring data-plane connectivity for the container creation operation itself:

```powershell
az storage container-rm create `
  --name $Container `
  --storage-account $StorageAccount `
  --resource-group $ResourceGroup `
  --public-access off
```

If `container-rm` is unavailable in the installed Azure CLI, update Azure CLI. Alternatively, run `az storage container create --auth-mode login` from a host connected to the private endpoint network.

## 9. Scope ongoing access to the container

Use least privilege by granting deployment identities access at container scope:

```powershell
$ContainerScope = "$StorageAccountId/blobServices/default/containers/$Container"
```

For the developer performing manual Terraform tests:

```powershell
az role assignment create `
  --assignee-object-id $CurrentUserObjectId `
  --assignee-principal-type User `
  --role "Storage Blob Data Contributor" `
  --scope $ContainerScope
```

For a GitHub OIDC identity, use its service principal object ID—not its application/client ID:

```powershell
az role assignment create `
  --assignee-object-id "<github-identity-object-id>" `
  --assignee-principal-type ServicePrincipal `
  --role "Storage Blob Data Contributor" `
  --scope $ContainerScope
```

Repeat for both GitHub plan and apply identities. After container-scoped permissions propagate, remove any broader storage-account assignment that is no longer required.

## 10. Verify security settings

```powershell
az storage account show `
  --name $StorageAccount `
  --resource-group $ResourceGroup `
  --query "{name:name,httpsOnly:enableHttpsTrafficOnly,tls:minimumTlsVersion,sharedKey:allowSharedKeyAccess,blobPublicAccess:allowBlobPublicAccess,networkAccess:publicNetworkAccess}" `
  --output table
```

Verify the container with Microsoft Entra authentication:

```powershell
az storage container show `
  --name $Container `
  --account-name $StorageAccount `
  --auth-mode login `
  --output table
```

This container verification command is a data-plane operation and must run from a host with private endpoint routing and DNS resolution.

## 11. Configure a manual Terraform deployment

From the connectivity deployment root, copy the backend template:

```powershell
Set-Location "terraform\landing-zones\Platform\Connectivity"
Copy-Item "backend.hcl.example" "backend.hcl"
```

Set the actual values in the local `backend.hcl` file:

```hcl
resource_group_name  = "rg-advocate-tfstate-westus3"
storage_account_name = "stadvocatetfstate<unique>"
container_name       = "tfstate"
key                  = "advocate/test/connectivity.tfstate"
subscription_id      = "<state-subscription-id>"
tenant_id            = "<tenant-id>"
use_oidc             = false
use_azuread_auth     = true
```

Use `use_oidc = false` for a manual deployment authenticated through Azure CLI. The local `backend.hcl` file is ignored by Git.

Initialize the backend:

```powershell
terraform init -reconfigure -backend-config="backend.hcl"
```

Successful initialization confirms that Terraform can authenticate and access the state container.

If initialization returns a timeout, DNS error, or HTTP 403, verify all three independent requirements: private endpoint routing, private DNS resolution, and `Storage Blob Data Contributor` access.

## 12. Configure GitHub environments

Configure these variables in each applicable GitHub environment, such as `test-plan`, `test-apply`, `prod-plan`, and `prod-apply`:

| GitHub variable | Value |
| --- | --- |
| `TFSTATE_RESOURCE_GROUP` | State resource group name |
| `TFSTATE_STORAGE_ACCOUNT` | State storage account name |
| `TFSTATE_CONTAINER` | State container name |
| `TFSTATE_SUBSCRIPTION_ID` | State subscription ID |
| `AZURE_TENANT_ID` | Microsoft Entra tenant ID |
| `AZURE_SUBSCRIPTION_ID` | Target deployment subscription ID |
| `AZURE_PLAN_CLIENT_ID` | Plan identity application/client ID |
| `AZURE_APPLY_CLIENT_ID` | Apply identity application/client ID |

The workflow enables OIDC and Microsoft Entra backend authentication. Do not configure a client secret or storage account key.

Because the storage account has public network access disabled, the plan and apply jobs use a self-hosted Linux runner with the `terraform-private` label. That runner must resolve and route to the Blob private endpoint. GitHub-hosted runners cannot access this backend. Follow [self-hosted-runner.md](self-hosted-runner.md) to provision and register the runner.

## 13. Verify the state blob

After the first successful Terraform apply, verify that the state blob exists:

```powershell
az storage blob show `
  --account-name $StorageAccount `
  --container-name $Container `
  --name "advocate/test/connectivity.tfstate" `
  --auth-mode login `
  --output table
```

Never edit or delete a Terraform state blob manually. Use Terraform state commands and Azure Blob versions or soft delete for controlled recovery.
