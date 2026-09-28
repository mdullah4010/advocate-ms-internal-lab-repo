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
- `resource_group`: `<org>-rg-<workload>-<purpose?>-<region>-<environment>-<instance>`
- `container_registry` and `storage_account`: separator-free constrained pattern

Private DNS zone names are not generated because the standard defines them as provider-controlled service exceptions.

The module validates controlled environment and region values, approved resource abbreviations, token syntax, instance formatting, and final resource-specific length and character constraints. Uniqueness itself must be checked against the target Azure scope during planning or deployment.
