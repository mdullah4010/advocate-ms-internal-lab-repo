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
  environment_code   = "azp"
  instance           = 1
}

# contoso-vnet-connect-eus2-azp-01
```

Set `purpose` to use the extended pattern. Set `uniqueness_suffix` only to an approved deterministic value for globally unique resources.

Special patterns:

- `management_group`: `<org>-<workload>`
- Function/workload resources: `<org>-<resource>-<workload>-<region>-<environment>-<instance>`
- Purpose/target resources: `<org>-<resource>-<purpose>-<region>-<environment>-<instance>`
- `resource_group`, `network_security_group`, and `subnet`: `<org>-<resource>-<workload>-<purpose>-<region>-<environment>-<instance>`
- Policy resources: `<org>-<resource>-<workload>-<purpose>`
- Application registrations and service principals omit the region token.
- `container_registry` uses a separator-free constrained form of the workload pattern.
- `storage_account` uses `<org>st<purpose><region><environment><instance>`.

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
