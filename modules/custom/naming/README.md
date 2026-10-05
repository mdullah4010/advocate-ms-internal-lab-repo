# Naming module

Generates deterministic lowercase Azure resource names from the Advocate Health DevOps Naming Convention Standard v1.1.

## Usage

```hcl
module "virtual_network_name" {
  source = "../../modules/custom/naming"

  resource_type      = "virtual_network"
  org_code           = "contoso"
  organization_codes = ["contoso"]
  workload           = "connect"
  workload_codes     = ["connect", "platform"]
  region_code        = "eus2"
  environment_code   = "prd"
  instance           = 1
}

# contoso-vnet-connect-eus2-prd-01
```

Set exactly one of `workload` or `purpose` as the resource's function/purpose token. Set `uniqueness_suffix` only to an approved deterministic value for globally unique resources.

Special patterns:

- Azure resource: `<org>-<resource>-<function-or-purpose>-<region>-<environment>-<instance>`
- Constrained Azure resource: `<org><resource><function-or-purpose><region><environment><instance>`
- Resource group: `<org>-rg-<function-or-purpose>-<region>-<environment>-<instance>`
- Management group: `<org>-mg-<function>`

Key Vault, Container Registry, and Storage Account use the constrained separator-free pattern.

Private DNS zone names are not generated because the standard defines them as provider-controlled service exceptions.

The module validates controlled environment and region values, approved resource abbreviations, token syntax, instance formatting, and final resource-specific length and character constraints. Uniqueness itself must be checked against the target Azure scope during planning or deployment.

## Examples and tests

The `tests` folder contains standalone module calls for a resource group, virtual network, subnet, public IP address, storage account, and management group. Preview all generated names without deploying Azure resources:

```powershell
Set-Location tests
terraform init -backend=false
terraform plan -var-file=test.auto.tfvars.example
```

Run the native assertion suite from this module's root with `terraform test`.
