# Event Hub → Function App → LogicMonitor: Build Record

Complete record of what was built, why, and how each piece was created. Covers the Azure
resources, the tenant policy blockers that shaped the design, the function code, and the
LogicMonitor integration.

Networking detail lives in [vnet-subnet-setup.md](vnet-subnet-setup.md). This document covers
everything else.

---

## 1. What this pipeline does

Azure diagnostic settings emit platform logs and metrics. LogicMonitor cannot read those directly,
so a bridge is needed:

```
Azure resources
   └─► diagnostic setting
        └─► Event Hub  (azureeventbridge)
             └─► Azure Function  (func-ehbridge-olk02)
                  └─► parse + reshape
                       └─► LM Logs ingestion API
```

The Function App is the only custom component. Everything either side of it is Azure or
LogicMonitor configuration.

### Why a Function App is required

LogicMonitor's own documentation specifies this exact topology — Event Hub, then an Azure Function
that "acts as the processing bridge between Azure logging services and LogicMonitor." The Event Hub
is a transport; something has to read from it, reshape the payload, and POST to LM.

Reference: [Azure Logs Ingestion Overview](https://www.logicmonitor.com/support/azure-logs-ingestion-overview)

### Why we built our own instead of using LogicMonitor's template

LogicMonitor publishes an ARM template ([logicmonitor/lm-logs-azure](https://github.com/logicmonitor/lm-logs-azure))
that deploys this whole stack. It provisions a plain storage account and function app.

In this tenant that template will fail, because policy forbids both shared-key access and public
network access on storage accounts (see §3). The stock template has no private endpoints and no
identity-based deployment storage. Our hand-built version exists specifically to satisfy those
constraints.

**This is the key point for the customer conversation:** the custom build is not a preference, it
is the workaround for a locked-down tenant. In a permissive tenant, the LM template is the better
choice.

---

## 2. Deployed resources

Subscription `39bd0c07-28f7-4177-bd4f-32e1f25c2cd9`, resource group `Test`, region `eastus`.

| Resource | Name | Created via | Notes |
| --- | --- | --- | --- |
| Virtual network | `vnet-ehbridge` | Portal | `10.10.0.0/16` |
| Subnet (app) | `snet-app` | Portal | `10.10.1.0/24`, delegated `Microsoft.App/environments` |
| Subnet (endpoints) | `snet-pe` | Portal | `10.10.2.0/24`, PE network policy disabled |
| Storage account | `stehbridge02` | CLI | Shared key off, public access off — both policy-enforced |
| Private endpoint | `pe-st-blob` | CLI | → `10.10.2.4` |
| Private endpoint | `pe-st-queue` | CLI | → `10.10.2.5` |
| Private endpoint | `pe-st-table` | CLI | → `10.10.2.6` |
| Private DNS zones | `privatelink.{blob,queue,table}.core.windows.net` | CLI | All three linked to the VNet |
| Function App | `func-ehbridge-olk02` | CLI | Flex Consumption, Python 3.13 |
| NAT Gateway | `nat-ehbridge` | CLI | Stable egress |
| Public IP | `pip-nat-ehbridge` | CLI | **`20.127.58.129`** — the IP LogicMonitor sees |
| Event Hub namespace | `adeventhub-test` | Pre-existing | |
| Event Hub | `azureeventbridge` | Pre-existing | |
| App Insights | (attached to function app) | CLI | appId `b6791397-dd0e-4762-ab80-31c72320f4d6` |

Three private endpoints are needed, not one. The Functions runtime uses blob for deployment
packages and leases, queue for internal scheduling, and table for Event Hub checkpoints. Missing
any one produces a host that starts but never processes events.

### Identities

| Identity | Value |
| --- | --- |
| System-assigned MI | enabled on `func-ehbridge-olk02` |
| User-assigned MI | `UAMI1` — clientId `bd1d6a6d-c5fd-4d0f-9410-7088362c2c33`, principalId `885f66b6-bc38-4971-912d-f695350206f5` |

### Role assignments

Granted to **both** identities:

| Role | Scope |
| --- | --- |
| Storage Blob Data Owner | `stehbridge02` |
| Storage Queue Data Contributor | `stehbridge02` |
| Storage Table Data Contributor | `stehbridge02` |
| Azure Event Hubs Data Receiver | `adeventhub-test` |

Both identities are assigned because the Flex Consumption deployment path and the runtime bindings
can resolve to different identities depending on configuration. Granting both removes a class of
intermittent failure that is painful to diagnose.

---

## 3. The four blockers and their fixes

These consumed most of the build time and are the most useful part of the handover.

### Blocker 1 — `allowSharedKeyAccess = false`

**Symptom:** `Key based authentication is not permitted on this storage account`

Tenant policy, not overridable. Every connection string is dead on arrival.

**Fix:** identity-based app settings instead of connection strings.

```
AzureWebJobsStorage__blobServiceUri   = https://stehbridge02.blob.core.windows.net
AzureWebJobsStorage__queueServiceUri  = https://stehbridge02.queue.core.windows.net
AzureWebJobsStorage__tableServiceUri  = https://stehbridge02.table.core.windows.net
AzureWebJobsStorage__credential       = managedidentity
AzureWebJobsStorage__clientId         = <UAMI1 clientId>
```

The plain `AzureWebJobsStorage` setting must be **deleted**, not left alongside. If present it wins,
and the identity settings are ignored.

### Blocker 2 — `publicNetworkAccess = Disabled`

**Symptom:** deployments fail, `az storage container list` is refused, function listing times out.

Setting `--public-network-access Enabled` appeared to succeed and silently reverted, twice. The
policy is a `Modify` effect applied above subscription scope, so it re-asserts continuously.

**Fix:** VNet + private endpoints for blob, queue and table + private DNS zones linked to the VNet.

Because the data plane is unreachable from a laptop, the deployment container had to be created
through the **control plane**:

```powershell
az storage container-rm create --storage-account stehbridge02 --name app-package
```

`az storage container create` (data plane) cannot work here.

### Blocker 3 — deployment storage auth must be set at creation time

**Symptom:** `functionAppConfig.deployment.storage.authentication` patched successfully via the ARM
API, but Kudu kept attempting key-based auth and deployments kept failing.

Cost four failed deploy cycles before the app was torn down and recreated.

**Fix:** set it in `az functionapp create`:

```powershell
az functionapp create ... --deployment-storage-auth-type UserAssignedIdentity `
  --deployment-storage-auth-value UAMI1
```

**Rule:** for Flex Consumption, deployment storage authentication is effectively immutable. Get it
right at create time or rebuild.

### Blocker 4 — public IP blocked by a dormant feature flag

**Symptom:**
`SubscriptionNotRegisteredForFeature ... Microsoft.Network/AllowBringYourOwnPublicIpAddress`

The name is misleading. It gates ordinary Standard SKU public IPs, not just BYOIP.

**Fix:**

```powershell
az feature register --namespace Microsoft.Network --name AllowBringYourOwnPublicIpAddress
az provider register -n Microsoft.Network --wait
```

---

## 4. Function App configuration

### App settings — connection related

Every one is identity-based. There is not a single connection string or key in the app.

| Setting | Value |
| --- | --- |
| `AzureWebJobsStorage__blobServiceUri` | `https://stehbridge02.blob.core.windows.net` |
| `AzureWebJobsStorage__queueServiceUri` | `https://stehbridge02.queue.core.windows.net` |
| `AzureWebJobsStorage__tableServiceUri` | `https://stehbridge02.table.core.windows.net` |
| `AzureWebJobsStorage__credential` | `managedidentity` |
| `AzureWebJobsStorage__clientId` | `bd1d6a6d-c5fd-4d0f-9410-7088362c2c33` |
| `EventHubConnection__fullyQualifiedNamespace` | `adeventhub-test.servicebus.windows.net` |
| `EventHubConnection__credential` | `managedidentity` |
| `EventHubConnection__clientId` | `bd1d6a6d-c5fd-4d0f-9410-7088362c2c33` |

The `EventHubConnection` prefix is arbitrary but must match the `connection=` argument on the
trigger decorator in code.

### Deployment

```powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + `
            [System.Environment]::GetEnvironmentVariable("Path","User")
func azure functionapp publish func-ehbridge-olk02 --build remote
```

`--build remote` is required. Dependencies are resolved on the platform, not locally, which avoids
wheel/architecture mismatches.

Portal code editing is disabled (`functionAppContentEditingState: NotAllowed`) because the app runs
from a deployment package. **All code changes go through source control and `func publish`** — there
is no portal click-path for the trigger.

---

## 5. Diagnostic settings — current state

Three exist. Only two matter.

| Setting | On resource | Destination | Verdict |
| --- | --- | --- | --- |
| `diag-func-to-eh-prod` | `lm-ds-test` | `azureeventbridge` | Legitimate source |
| `diag-stebridgeblob-to-eh` | `stehbridge02/blobServices/default` | `azureeventbridge` | **Feedback loop — remove** |
| `setByPolicy-MCAPSGovernance` | `lm-ds-test` | Tenant Log Analytics workspace | Tenant governance, unrelated |

Both Event Hub settings authenticate with the namespace-level `RootSendListenAccessKey` rule.

### The feedback loop

`diag-stebridgeblob-to-eh` forwards `Transaction` metrics from the function's **own deployment
storage account**:

```
function checkpoints to stehbridge02
   └─► RenewBlobLease / SetBlobMetadata / ListBlobs
        └─► Transaction metrics
             └─► diag-stebridgeblob-to-eh
                  └─► azureeventbridge
                       └─► function reads it, checkpoints again ↻
```

The app can never go idle — it manufactures its own input. Volume is bounded rather than
exponential because Transaction metrics aggregate per minute, and `StorageRead`/`StorageWrite`/
`StorageDelete` log categories are disabled. Only the metric category is on.

Left in place, every one of those self-generated records ships to LogicMonitor once dry-run is
turned off. The customer pays ingestion for the bridge watching its own plumbing.

**Remove it:**

```powershell
az monitor diagnostic-settings delete --name diag-stebridgeblob-to-eh `
  --resource "/subscriptions/39bd0c07-28f7-4177-bd4f-32e1f25c2cd9/resourceGroups/Test/providers/Microsoft.Storage/storageAccounts/stehbridge02/blobServices/default"
```

**General rule:** never point a diagnostic setting at infrastructure the log pipeline itself depends
on. The storage account, the Event Hub namespace, and the bridge function app are all off-limits as
sources.

### On `lm-ds-test`

A second, separate function app. It is **not part of the pipeline** — it is only a convenient log
*source*, because its `FunctionAppLogs` feed the Event Hub via `diag-func-to-eh-prod`.

It has no VNet and its storage has no private endpoints, so it is not a working reference for the
architecture. It is useful for one thing: restarting it produces a burst of host-startup logs, which
is a zero-cost way to push real diagnostic traffic through the pipeline.

In production this app is unnecessary. Real sources are whichever resources the customer wants
monitored.

### Notes on choosing sources

Diagnostic categories are resource-type specific with essentially no overlap except `AllMetrics`.
For storage accounts, settings live on **sub-resources** (`/blobServices/default`), not the account
itself — a common reason a portal-created setting appears to vanish.

At scale, Azure Policy `DeployIfNotExists` is the right answer for coverage rather than per-resource
clicking. This tenant already does exactly that via `setByPolicy-MCAPSGovernance`.

---

## 6. The code

Single file: [function_app.py](../function_app.py).

### The trigger

```python
@app.event_hub_message_trigger(arg_name="azeventhub", event_hub_name="azureeventbridge",
                               connection="EventHubConnection")
def eventhub_trigger(azeventhub: func.EventHubEvent):
```

`connection="EventHubConnection"` is a **prefix**, not a value. The runtime looks for app settings
beginning with that string — `EventHubConnection__fullyQualifiedNamespace`, `__credential`,
`__clientId`. This is what makes the identity-based, secretless connection work.

### The problem the transformation solves

Azure diagnostic settings do not send one log per event. They batch many records into a single
Event Hub message:

```json
{"records": [ {...}, {...}, {...} ]}
```

The original scaffold decoded the whole blob and logged it as one line, which is why only one log
line ever appeared no matter how much data arrived.

Three specific issues had to be handled:

1. **One event carries many records.** `parse_records()` unwraps the envelope and emits one entry
   per record.
2. **Field names are not stable across resource types.** Some use `time`, others `timeStamp`; some
   `level`, others `Level`. Everything is normalised to a fixed schema.
3. **Not every event is the envelope.** Plain strings and bare JSON objects both occur. Both fall
   through to sane handling rather than raising — an exception here would fail the whole batch,
   trigger retries, and eventually dead-letter good data along with bad.

### Verification

Tested locally against three payload shapes before deploying — a two-record diagnostic envelope, a
plain-text event, and a bare JSON object without a `records` wrapper. All three produced correct
output.

Then confirmed against **real Azure data** in App Insights:

```json
{"message":"{...}","timestamp":"2026-09-16T04:35:00.0000000Z",
 "azure_resource_id":"/SUBSCRIPTIONS/.../STEHBRIDGE02/BLOBSERVICES/DEFAULT",
 "_lm.resourceId":{"system.azure.resourceid":"/SUBSCRIPTIONS/..."}}
```

---

## 7. LogicMonitor integration

### API contract

From [Sending Logs to Ingestion API](https://www.logicmonitor.com/support/lm-logs/sending-logs-to-ingestion-api).

| Item | Value |
| --- | --- |
| Endpoint | `https://<account>.logicmonitor.com/rest/log/ingest` |
| Method | POST |
| Content-Type | `application/json` |
| Auth header | `Authorization: LMv1 <AccessId>:<Signature>:<Timestamp>` |
| Body | JSON **array** of event objects |

Base URL is `/rest`, **not** `/santaba/rest` — that is the general REST API, a different endpoint.

### The LMv1 signature

```
signature = base64( hex( HMAC-SHA256( AccessKey, VERB + TIMESTAMP + BODY + RESOURCE_PATH ) ) )
```

Two details that are easy to get wrong:

- The HMAC **hex digest** is base64-encoded, not the raw digest bytes. A correct signature is 88
  characters (base64 of a 64-char hex string). This is verified in the implementation.
- The body must be serialised **once** and the identical string used for both signing and sending.
  Serialising twice can produce different bytes and a signature that never validates.

`RESOURCE_PATH` is `/log/ingest` — the path only, without the `/rest` base.

### Field mapping

LogicMonitor's own Azure integration extracts these fields, so the same mapping is used:

| Azure record field | LM field | Implemented |
| --- | --- | --- |
| `time` | `timestamp` | yes |
| `level` | `severity` | yes |
| `operationName` | `activity_type` | yes |
| `resourceId` | `azure_resource_id` | yes |
| `category` | `category` | yes |
| — | `message` (**required**) | yes |
| — | `_lm.resourceId` | yes |

`message` is mandatory. An event without it is rejected with error 4004 and never reaches the
pipeline. Everything else is optional.

`_lm.resourceId` is what maps a log to a resource already discovered in LogicMonitor. It is
optional for ingestion but without it logs arrive unmapped — LM's docs call these "deviceless logs"
and recommend against them.

### Limits enforced in code

| Limit | Value | Handling |
| --- | --- | --- |
| Max single message | 32 KB | Truncated with a `...[truncated]` marker |
| Max payload | 8 MB | Not chunked — a single Event Hub event caps at 1 MB, so the derived batch cannot approach 8 MB |
| Event age window | ±3 hours | Not handled; stale replays would return error 4006 |
| Rate limit | 240K requests/min per account | Not a practical concern at this volume |

### Response handling

| Status | Meaning | Behaviour |
| --- | --- | --- |
| 202 | Accepted | Log success |
| 207 | Partial — some events rejected | Log the `errors` array, do **not** raise |
| 429 / 5xx | Transient | **Raise** — prevents checkpoint advance so the batch is retried |
| Other 4xx | Bad payload or bad credentials | Log error, do **not** raise |

The raise/don't-raise split is deliberate. Raising on a transient error gets the data redelivered.
Raising on a malformed payload would retry the same bad batch forever and stall the partition — a
poison-pill. Transient failures are worth retrying; permanent ones are not.

Custom error codes worth recognising: `4001` resource not found, `4003` insufficient information for
device lookup, `4004` missing message field, `4006` event outside the time window.

### Configuration

Six settings, split by who can know the answer.

**Already set** (no LM account required):

| Setting | Value | Purpose |
| --- | --- | --- |
| `LM_DRY_RUN` | `true` | Parse and log only; never POST |
| `LM_DOMAIN` | `logicmonitor.com` | Also `lmgov.us` for government tenants |
| `LM_RESOURCE_PROPERTY` | `system.azure.resourceid` | Property LM matches on for resource mapping |

**Customer supplies:**

| Setting | Source |
| --- | --- |
| `LM_COMPANY` | Account name only — the `<account>` in `<account>.logicmonitor.com`, not the full URL |
| `LM_ACCESS_ID` | API token Access ID |
| `LM_ACCESS_KEY` | API token Access Key — Key Vault reference recommended |

Set via **Portal → Settings → Environment variables → App settings → + Add**. The key should go in
through the portal rather than CLI, so it does not land in shell history.

`local.settings.json` is **not deployed** — `func publish` deliberately skips it. Azure needs its
own copy of every setting.

### Dry-run

With `LM_DRY_RUN=true` the function parses normally and logs each entry as `LM_ENTRY <json>` instead
of POSTing. That JSON is exactly what would be sent.

This is what makes the app safe to hand over without credentials, and it lets the payload shape be
validated independently of LogicMonitor access. Flip to `false` to go live.

---

## 8. Does the Entra app registration matter?

Yes — but **not to this function app**. Nothing in the code reads it.

| Credential | Used by | For |
| --- | --- | --- |
| Entra app registration | LogicMonitor platform | Polling Azure Monitor to **discover** resources |
| Managed identity | This function app | Reading from the Event Hub |
| LM API token | This function app | Authenticating the POST to LM Logs |

The app registration is what populates LM with Azure resources in the first place. Without it,
`_lm.resourceId` has nothing to match against and logs arrive unmapped.

LogicMonitor also requires the app registration's client ID as a parameter when deploying their own
function template, which is further evidence it is about resource mapping rather than log transport.

Reference: [Adding Microsoft Azure Cloud Monitoring](https://www.logicmonitor.com/support/lm-cloud/getting-started-lm-cloud/adding-microsoft-azure-cloud-monitoring)

---

## 9. Go-live checklist

| # | Item | Owner | Status |
| --- | --- | --- | --- |
| 1 | `LM_COMPANY` / `LM_ACCESS_ID` / `LM_ACCESS_KEY` set | you, from customer values | pending |
| 2 | `LM_DRY_RUN` → `false` | you | currently `true` |
| 3 | Remove `diag-stebridgeblob-to-eh` | you | **loop is live** |
| 4 | Diagnostic settings on the resources the customer actually wants monitored | you | only test sources exist |
| 5 | LM Logs feature enabled on the account | customer | unknown — 402 if missing |
| 6 | API token user has **Manage** permission on Logs | customer | unknown — 403 if missing |
| 7 | Azure cloud account added in LM (app registration) | customer | unknown — 4001 if missing |
| 8 | `LM_RESOURCE_PROPERTY` matches their setup | you | **inferred, unverified** |
| 9 | Allowlist NAT egress IP `20.127.58.129` if LM restricts source IPs | customer | unknown |

Item 8 is the one genuine unknown in the code. LogicMonitor documents the `_lm.resourceId`
*mechanism* but not the exact Azure property name. Wrong value produces error 4001 or 4003 — visible
in the logs, and fixable by changing one app setting with no redeploy.

Expected first-run outcome: HTTP 202 with logs arriving **unmapped**. That means transport and auth
are correct and only the mapping key needs adjusting. Each failure mode points at exactly one row
above.

---

## 10. Loose ends

| Item | Action |
| --- | --- |
| `Eh-FA-BridgeAccessKey` on `azureeventbridge` | Confirmed unused — both diagnostic settings use `RootSendListenAccessKey`. Safe to rotate or delete |
| Temporary `Azure Event Hubs Data Sender` role on user `61715a45-e517-4172-95dd-83dac3756fe4` | Remove — was only for manual send tests |
| Orphaned App Insights component `func-ehbridge-olk01` | Delete — left from the first, torn-down app |
| Terraform module | Not started. `terraform` is not installed. Pin the provider version and confirm the `azurerm_function_app_flex_consumption` schema before writing |

---

## 11. Gotchas worth carrying forward

**`state: Running` on a Function App is site state, not function health.** An app can report
Running while processing nothing. Check invocation traces instead.

**`az functionapp show --query functionAppConfig` returns empty.** Use
`az rest` with `api-version=2023-12-01`.

**PATCHing `functionAppConfig` requires the full block** — runtime *and* scaleAndConcurrency — or it
returns 400 "Runtime is invalid".

**`DefaultAzureCredential` fails on machines running the Azure Arc agent**, dying inside
`ManagedIdentityCredential` with `WinError 5`. Use `AzureCliCredential` explicitly for local scripts.

**JMESPath projections with braces break through the `az` CLI shim on Windows.**
`--query "[?x].{a:a,b:b}"` fails with "was unexpected at this time". Filter in PowerShell instead.

**Azure Monitor metric queries need explicit UTC.** `(Get-Date).AddHours(-24).ToString("...Z")`
formats *local* time with a `Z` suffix, producing a wrong window and misleading empty results. Use
`.ToUniversalTime()`. This caused a false "no traffic" reading during this build.

**An idle diagnostic source produces nothing.** `FunctionAppLogs` only emits when the app does
something. A correctly configured pipeline with an idle source looks identical to a broken one.
Check Event Hub `IncomingMessages` to tell them apart.
