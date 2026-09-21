# Terraform Modules

Reusable Terraform modules shared by the deployment roots in this repository.

> This is an aggregate module catalog formatted similarly to `terraform-docs`. Each child directory is an independent Terraform module; the `modules` directory itself is not a Terraform root module.

## Modules

| Name | Source | Description |
| --- | --- | --- |
| `management-group` | [`./management-group`](./management-group) | Creates one Azure management group under an existing parent management group. |
| `resource-group` | [`./resource-group`](./resource-group) | Creates one Azure resource group. |
| `role-assignment` | [`./role-assignment`](./role-assignment) | Creates one Azure role assignment at a specified scope. |
| `subnet` | [`./subnet`](./subnet) | Creates one subnet in an existing virtual network. |
| `virtual-network` | [`./avm/virtual-network`](./avm/virtual-network) | Wraps the Azure Verified Virtual Network Module version `0.22.2`. |

## Management group

### Resources

| Name | Type |
| --- | --- |
| `azurerm_management_group.this` | resource |

### Inputs

| Name | Description | Type | Default | Required |
| --- | --- | --- | --- | :---: |
| `name` | Stable management group ID. | `string` | n/a | yes |
| `display_name` | Human-readable management group display name. | `string` | n/a | yes |
| `parent_management_group_id` | Full resource ID of the parent management group. | `string` | n/a | yes |

### Outputs

| Name | Description |
| --- | --- |
| `id` | Management group resource ID. |
| `name` | Management group ID. |

## Resource group

### Resources

| Name | Type |
| --- | --- |
| `azurerm_resource_group.this` | resource |

### Inputs

| Name | Description | Type | Default | Required |
| --- | --- | --- | --- | :---: |
| `name` | Name of the Azure resource group. | `string` | n/a | yes |
| `location` | Azure region for the resource group. | `string` | n/a | yes |
| `tags` | Tags applied to the resource group. | `map(string)` | `{}` | no |

### Outputs

| Name | Description |
| --- | --- |
| `id` | Resource ID of the resource group. |
| `name` | Name of the resource group. |
| `location` | Azure region of the resource group. |

## Role assignment

Exactly one of `role_definition_name` or `role_definition_id` must be provided.

### Resources

| Name | Type |
| --- | --- |
| `azurerm_role_assignment.this` | resource |

### Inputs

| Name | Description | Type | Default | Required |
| --- | --- | --- | --- | :---: |
| `scope` | Azure resource ID on which to assign the role. | `string` | n/a | yes |
| `principal_id` | Microsoft Entra object ID of the group, service principal, or managed identity. | `string` | n/a | yes |
| `role_definition_name` | Built-in role name. Set either this or `role_definition_id`. | `string` | `null` | no |
| `role_definition_id` | Role definition resource ID. Set either this or `role_definition_name`. | `string` | `null` | no |
| `description` | Purpose of the role assignment. | `string` | n/a | yes |
| `principal_type` | Optional principal type: `Group`, `ServicePrincipal`, or `User`. | `string` | `null` | no |
| `skip_service_principal_aad_check` | Skip the Entra replication check for newly created service principals. | `bool` | `false` | no |

### Outputs

| Name | Description |
| --- | --- |
| `id` | Role assignment resource ID. |

## Subnet

### Resources

| Name | Type |
| --- | --- |
| `azurerm_subnet.this` | resource |

### Inputs

| Name | Description | Type | Default | Required |
| --- | --- | --- | --- | :---: |
| `name` | Name of the subnet. | `string` | n/a | yes |
| `resource_group_name` | Name of the resource group containing the virtual network. | `string` | n/a | yes |
| `virtual_network_name` | Name of the virtual network containing the subnet. | `string` | n/a | yes |
| `address_prefixes` | CIDR address prefixes assigned to the subnet. | `list(string)` | n/a | yes |
| `private_endpoint_network_policies_enabled` | Whether private endpoint network policies are enabled for the subnet. | `bool` | `true` | no |

### Outputs

| Name | Description |
| --- | --- |
| `id` | Resource ID of the subnet. |
| `name` | Name of the subnet. |

## Virtual network

This wrapper preserves the repository's virtual-network interface while using [`Azure/avm-res-network-virtualnetwork/azurerm`](https://registry.terraform.io/modules/Azure/avm-res-network-virtualnetwork/azurerm/0.22.2) version `0.22.2`.

The wrapper obtains the active subscription ID from `azurerm_client_config.current` and combines it with `resource_group_name` to construct the AVM `parent_id`.

### Requirements

| Name | Version |
| --- | --- |
| Terraform | `>= 1.16.0, < 2.0.0` at the connectivity root |
| Azure Virtual Network AVM | `0.22.2` |

### Providers

| Name | Version |
| --- | --- |
| `azurerm` | `~> 4.0` at the connectivity root |
| `azapi` | Transitive AVM dependency |
| `modtm` | Transitive AVM dependency |
| `random` | Transitive AVM dependency |

### Modules

| Name | Source | Version |
| --- | --- | --- |
| `this` | `Azure/avm-res-network-virtualnetwork/azurerm` | `0.22.2` |

### Data sources

| Name | Type |
| --- | --- |
| `azurerm_client_config.current` | data source |

### Inputs

| Name | Description | Type | Default | Required |
| --- | --- | --- | --- | :---: |
| `name` | Name of the Azure virtual network. | `string` | n/a | yes |
| `location` | Azure region for the virtual network. | `string` | n/a | yes |
| `resource_group_name` | Name of the resource group containing the virtual network. | `string` | n/a | yes |
| `address_space` | CIDR address spaces assigned to the virtual network. | `list(string)` | n/a | yes |
| `dns_servers` | Optional custom DNS server IPv4 addresses. | `list(string)` | `[]` | no |
| `tags` | Tags applied to the virtual network. | `map(string)` | `{}` | no |

### Outputs

| Name | Description |
| --- | --- |
| `id` | Resource ID of the virtual network. |
| `name` | Name of the virtual network. |

## Usage

Production deployment roots are under `envs/prod`. Platform deployment roots are under `Platform`, and test configuration is under `envs/test`.

Run `terraform fmt`, `terraform init`, and `terraform validate` from the applicable deployment root after changing a module. Commit dependency lock-file changes when module or provider selections change.
