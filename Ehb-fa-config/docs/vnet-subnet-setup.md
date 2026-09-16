# VNet and Subnet Setup — Event Hub to LogicMonitor Function App

Runbook for building the virtual network that hosts the Event Hub → Function App → LogicMonitor
log pipeline. Values below match the deployed `vnet-ehbridge` in resource group `Test`.

## Why this VNet exists

Tenant policy enforces two settings on every storage account and they cannot be overridden:

| Policy | Effect |
| --- | --- |
| `allowSharedKeyAccess = false` | No connection strings or account keys — managed identity only |
| `publicNetworkAccess = Disabled` | Storage reachable **only** through a private endpoint |

Azure Functions always needs a storage account for its runtime and for Event Hub checkpointing.
With no VNet, nothing can reach that storage — not a laptop, not the Functions platform. The VNet
is therefore mandatory, not an optimisation.

## Prerequisites

- Resource group exists (`Test`)
- Region matches the Event Hub namespace and storage account (`East US`)
- `Microsoft.Network` resource provider registered
  (`az provider register -n Microsoft.Network`) — it was *not* registered on a fresh subscription
- `Microsoft.App` resource provider registered, or the subnet delegation dropdown will be empty
- Address range confirmed not to collide with hub or on-premises networks

## Target design

| Component | Value | Purpose |
| --- | --- | --- |
| VNet | `vnet-ehbridge`, `10.10.0.0/16` | Container for both subnets |
| Subnet 1 | `snet-app`, `10.10.1.0/24` | Function App integration, delegated |
| Subnet 2 | `snet-pe`, `10.10.2.0/24` | Private endpoint NICs |

Two subnets are required, not stylistic. A delegated subnet cannot host private endpoints, so the
app and the endpoints must be separated.

---

## Portal steps

### Tab 1 — Basics

| Field | Value |
| --- | --- |
| Subscription | `MCAPS-Hybrid-REQ-162273-2026-olkolawole` |
| Resource group | `Test` |
| Virtual network name | `vnet-ehbridge` |
| Region | `(US) East US` |

The portal may pre-select a different resource group — change it. Region is not a free choice: a
private endpoint must be in the same region as its VNet, and the Event Hub and storage are both in
East US.

### Tab 2 — Security

Leave **all four unchecked**. Each is a paid add-on and none apply here.

| Option | Setting | Reason |
| --- | --- | --- |
| Virtual network encryption | Off | Requires VMs with accelerated networking; there are none |
| Azure Bastion | Off | For RDP/SSH to VMs; there are none |
| Azure Firewall | Off | Would add a UDR and force-tunnel egress, breaking the NAT Gateway path |
| Azure DDoS Network Protection | Off | Protects public inbound; there is no public inbound surface |

If a customer's platform team mandates Azure Firewall, the egress design changes — outbound would
route through the firewall and the IP given to LogicMonitor becomes the firewall's, not the NAT
Gateway's.

### Tab 3 — Address space

The portal defaults to `10.0.0.0/16` with a subnet named `default` at `10.0.0.0/24`.

1. Change the address space to **`10.10.0.0/16`**.
2. Delete the auto-created `default` subnet. Once the address space changes, `10.0.0.0/24` falls
   outside the range and the portal blocks you until it is removed.
3. Add the two subnets below.

**Subnet 1 — `snet-app`**

| Field | Value |
| --- | --- |
| Name | `snet-app` |
| Starting address | `10.10.1.0` |
| Size | `/24` (256 addresses) |
| **Subnet delegation** | **`Microsoft.App/environments`** |
| NAT gateway | `nat-ehbridge` (only if already created) |
| Network security group | None |
| Route table | None |
| Service endpoints | None |

**Subnet 2 — `snet-pe`**

| Field | Value |
| --- | --- |
| Name | `snet-pe` |
| Starting address | `10.10.2.0` |
| Size | `/24` (256 addresses) |
| Subnet delegation | **None** |
| Private endpoint network policy | Disabled |
| NAT gateway / NSG / Route table | None |
| Service endpoints | None |

### Tab 4 — Tags

Optional. Recommended for customer engagements so resources stay traceable, e.g.
`project = logicmonitor-integration`.

### Tab 5 — Review + create

Confirm address space is `10.10.0.0/16`, both subnets are present, and `snet-app` shows the
delegation before creating.

---

## CLI equivalent

```powershell
az network vnet create -g Test -n vnet-ehbridge -l eastus `
  --address-prefix 10.10.0.0/16 `
  --subnet-name snet-app --subnet-prefix 10.10.1.0/24

az network vnet subnet update -g Test --vnet-name vnet-ehbridge -n snet-app `
  --delegations Microsoft.App/environments

az network vnet subnet create -g Test --vnet-name vnet-ehbridge -n snet-pe `
  --address-prefix 10.10.2.0/24 --private-endpoint-network-policies Disabled

# after the NAT Gateway exists
az network vnet subnet update -g Test --vnet-name vnet-ehbridge -n snet-app `
  --nat-gateway nat-ehbridge
```

## Verification

```powershell
az network vnet subnet list -g Test --vnet-name vnet-ehbridge `
  --query "[].{name:name, prefix:addressPrefix, delegation:delegations[0].serviceName, pePolicy:privateEndpointNetworkPolicies, nat:natGateway.id}" -o table
```

Expected:

```
Name      Prefix        Delegation                  PePolicy   Nat
--------  ------------  --------------------------  ---------  --------------------
snet-app  10.10.1.0/24  Microsoft.App/environments  Disabled   .../nat-ehbridge
snet-pe   10.10.2.0/24                              Disabled   (none)
```

If `snet-app` shows no delegation, stop — Function App VNet integration will fail to attach later.

---

## The critical settings

**`snet-app` delegated to `Microsoft.App/environments`.** The single most important field in the
whole wizard. Without it, Flex Consumption VNet integration silently fails. Easy to miss because
delegation sits near the bottom of the subnet panel.

**`snet-pe` must NOT be delegated.** A delegated subnet cannot host private endpoints.

**Private endpoint network policy disabled on `snet-pe`.** Required before private endpoints can be
created. Recent API versions default new subnets to `Disabled`, so this may already be set — setting
it explicitly is harmless and self-documenting.

## Constraints to plan around

**Subnet prefixes cannot be resized once resources are attached.** Flex Consumption consumes
addresses from `snet-app` as it scales out. An undersized subnet becomes a hard scaling ceiling and
the only fix is rebuilding the VNet and everything in it. `/24` gives 251 usable addresses — do not
shrink it to "save space"; private address space is free.

**Do not set custom DNS servers on this VNet.** Private endpoint resolution depends on
Azure-provided DNS reaching the `privatelink.*` zones. Custom DNS silently breaks storage
resolution, and the symptom looks identical to storage being unreachable.

**Confirm the address range before deploying into a customer tenant.** Overlapping ranges make
future VNet peering impossible without a rebuild.

## Troubleshooting

| Symptom | Cause | Fix |
| --- | --- | --- |
| Delegation dropdown empty or missing `Microsoft.App/environments` | Resource provider not registered | `az provider register -n Microsoft.App` |
| "Subnet is in use and cannot be delegated" | Resources already occupy the subnet | Delegate before attaching anything |
| Cannot create a private endpoint in the subnet | Private endpoint network policy enabled | Set it to Disabled on `snet-pe` |
| Portal blocks you on the Address space tab | Leftover `default` subnet outside the new range | Delete the `default` subnet |
| NAT gateway dropdown empty | Gateway does not exist yet | Create it first, or attach from the subnet blade afterwards |
| `Resource provider 'Microsoft.Network' is not registered` | Fresh subscription | `az provider register -n Microsoft.Network` |

## What comes next

This VNet is step one. The remaining build order is:

1. Storage account (`stehbridge02`)
2. Private endpoints for **blob, queue and table** + private DNS zones linked to this VNet
3. Deployment container, created via ARM (`az storage container-rm create`) because the data plane
   is unreachable once storage is private-only
4. Function App with `--vnet` / `--subnet` **and** `--deployment-storage-auth-type` set at creation
   time — setting deployment auth afterwards does not work
5. RBAC role assignments and identity-based app settings
6. NAT Gateway for stable outbound to LogicMonitor

All six steps, the function code, and the LogicMonitor integration are recorded in
[eventhub-to-logicmonitor-build.md](eventhub-to-logicmonitor-build.md).
