# Configure a private-network GitHub Actions runner

This guide configures a repository-level self-hosted Linux runner that can execute Terraform against an Azure Storage account whose public network access is disabled. It reflects the Ubuntu VM installation used for this repository.

GitHub automatically assigns these labels to a Linux x64 self-hosted runner:

- `self-hosted`
- `linux`
- `x64`

The current connectivity workflow uses `runs-on: self-hosted`. Adding the custom label `terraform-private` and selecting the runner with `runs-on: [self-hosted, linux, terraform-private]` is recommended when the repository has more than one self-hosted runner. This prevents a runner without private-backend connectivity from accepting the job.

The pull-request validation workflow remains on a GitHub-hosted runner because it initializes Terraform with the backend disabled.

## Architecture

See [self-hosted-runner-private-backend-architecture.md](self-hosted-runner-private-backend-architecture.md) for the runner, subnet, private endpoint, private DNS, storage, and OIDC architecture diagram.

Place an Ubuntu virtual machine in either:

- the virtual network containing the Terraform-state Blob private endpoint; or
- a peered/connected virtual network that can route to the private endpoint and use its private DNS zone.

The VM needs outbound HTTPS to GitHub but does not need inbound Internet access for the runner service. Prefer no public IP and administer it through Azure Bastion, a private management network, or an approved privileged access path. If a public IP is temporarily required for initial lab setup, restrict inbound SSH to the administrator's source IP and remove the public IP afterward.

Use a dedicated runner subscription or management resource group where practical. Do not install the runner on a domain controller, production workload VM, or administrator workstation.

## 1. Prepare the runner network

Create or select a dedicated runner subnet. Apply an NSG that:

- permits required outbound TCP 443 traffic to GitHub Actions endpoints;
- permits DNS to the approved Azure/custom DNS resolvers;
- permits routing to the storage private endpoint on TCP 443; and
- denies unnecessary inbound access.

GitHub endpoint requirements can change. Follow GitHub's current self-hosted runner communication documentation rather than maintaining broad static IP allowlists. If outbound traffic passes through Azure Firewall or a proxy, allow the documented GitHub domains and test TLS without interception that breaks certificate validation.

Link the `privatelink.blob.core.windows.net` private DNS zone to the runner VNet. If custom DNS is used, configure a conditional forwarder for that zone to Azure DNS Private Resolver or another resolver connected to Azure private DNS.

## 2. Create the runner VM

Recommended starting configuration for one Terraform job at a time:

- Ubuntu Server LTS, x64
- 2 vCPU and 4–8 GB RAM
- 30 GB or larger OS disk
- System-assigned managed identity enabled for VM administration/monitoring where required
- No public IP
- Automatic security updates and Defender/EDR enabled
- Disk encryption and approved backup/patching configuration

Terraform authentication in this repository uses GitHub OIDC, not the VM managed identity. Do not grant the VM identity landing-zone deployment permissions unless a separate approved design requires it.

## 3. Connect to and prepare Ubuntu

Connect through Azure Bastion or another approved private management path. If a temporary public IP is approved for lab setup, restrict TCP 22 in the NSG to the administrator's source IP before connecting:

```bash
ssh <username>@<vm-address>
```

Update Ubuntu and install the baseline packages:

```bash
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y ca-certificates curl git jq tar unzip wget
```

Verify the baseline tools:

```bash
git --version
curl --version
```

## 4. Verify private network connectivity

Connect to the VM through the approved private management path and verify DNS:

```bash
getent hosts <state-storage-account>.blob.core.windows.net
```

The hostname must resolve through `privatelink.blob.core.windows.net` to the storage private endpoint's private IP.

Verify TCP/TLS connectivity:

```bash
curl -I https://<state-storage-account>.blob.core.windows.net/
```

An Azure HTTP response such as `400` or `403` proves network connectivity; authentication is tested later. A timeout or DNS failure indicates a private routing or DNS problem.

Verify outbound connectivity to GitHub:

```bash
curl -I https://github.com
curl -I https://api.github.com
```

## 5. Create a dedicated operating-system account

```bash
sudo useradd --create-home --shell /bin/bash github-runner
sudo mkdir -p /opt/actions-runner
sudo chown github-runner:github-runner /opt/actions-runner
```

Do not run workflow jobs as `root`. Do not add the account to unrestricted `sudo` or Docker groups unless those capabilities are explicitly required and risk-approved.

Switch to the runner account and working directory before downloading or configuring the runner:

```bash
sudo -iu github-runner
cd /opt/actions-runner
```

## 6. Add the repository runner in GitHub

For a repository-level runner:

1. Open the repository in GitHub.
2. Select **Settings → Actions → Runners**.
3. Select **New self-hosted runner**.
4. Choose **Linux** and **x64**.

If organization-level runner groups are available, place the runner in a group restricted to this repository or an approved set of infrastructure repositories. Do not allow a private infrastructure runner to service public repositories.

## 7. Download and verify the runner

GitHub displays commands containing the current runner release, download URL, and SHA-256 checksum. Run those exact commands as `github-runner` from `/opt/actions-runner`; do not copy a fixed runner version or checksum from this guide.

The generated commands follow this pattern:

```bash
curl -o actions-runner-linux-x64-<version>.tar.gz -L \
  https://github.com/actions/runner/releases/download/v<version>/actions-runner-linux-x64-<version>.tar.gz

echo "<sha256>  actions-runner-linux-x64-<version>.tar.gz" | sha256sum -c
tar xzf actions-runner-linux-x64-<version>.tar.gz
```

The checksum command must report `OK` before continuing. If it fails, delete the archive and repeat the GitHub-generated commands.

Install any operating-system dependencies required by the downloaded runner. Exit the `github-runner` shell temporarily because this command requires administrative access:

```bash
exit
cd /opt/actions-runner
sudo ./bin/installdependencies.sh
sudo chown -R github-runner:github-runner /opt/actions-runner
sudo -iu github-runner
cd /opt/actions-runner
```

## 8. Register the runner

Use the repository URL and short-lived registration token displayed by GitHub:

```bash
./config.sh \
  --url https://github.com/<organization>/<repository> \
  --token <new-registration-token> \
  --name az-tf-private-01 \
  --labels terraform-private \
  --work _work
```

Alternatively, run only the GitHub-generated `./config.sh` command and answer the interactive prompts.

During interactive configuration:

- use the default runner group selected in GitHub;
- give the runner a descriptive name such as `az-tf-private-01`;
- add the custom label `terraform-private`;
- use `_work` as the work directory; and
- do not remove the default `self-hosted`, `linux`, and architecture labels.

The registration token is short-lived and sensitive. Generate a new token if one has been copied into chat, email, documentation, source control, or logs. Enter it only on the VM and never store it as a GitHub Actions secret, Terraform variable, or repository file.

For repeatable provisioning at scale, use GitHub's just-in-time runner registration API or an approved autoscaling runner solution instead of storing registration tokens.

Before installing the service, an optional foreground test can confirm registration:

```bash
./run.sh
```

Wait for `Listening for Jobs`, confirm that the runner is **Online** in GitHub, and then stop the foreground process with `Ctrl+C`.

## 9. Install the runner as a service

Exit the runner account, then install the generated systemd service under the dedicated account:

```bash
exit
cd /opt/actions-runner
sudo ./svc.sh install github-runner
sudo ./svc.sh start
sudo ./svc.sh status
```

Confirm in GitHub that the runner is **Idle** and displays the `terraform-private` label.

Useful service commands are:

```bash
sudo ./svc.sh stop
sudo ./svc.sh start
sudo ./svc.sh status
```

## 10. Install Azure CLI

The repository workflows use `azure/login` followed by `az` commands, so Azure CLI must be installed on the persistent runner. Install it using Microsoft's Debian/Ubuntu installer:

```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az version
```

Keep Azure CLI patched with the operating system. The workflow authenticates Azure CLI through GitHub OIDC; do not run a persistent interactive `az login` for the runner service account.

## 11. Terraform and other tooling

The workflow installs its pinned Terraform version through `hashicorp/setup-terraform`, so Terraform does not need to be installed permanently on the VM. This keeps the runner version aligned with the workflow.

Bicep is not required by the current Terraform workflows. Install additional tools only when a reviewed workflow requires them.

Keep the OS and runner application patched. The runner normally updates itself, but operational monitoring should alert if it goes offline or cannot update.

## 12. Configure GitHub OIDC identities

Create federated credentials for the GitHub plan and apply identities. The subject must match each protected GitHub environment, for example:

```text
repo:<organization>/<repository>:environment:test-plan
repo:<organization>/<repository>:environment:test-apply
repo:<organization>/<repository>:environment:prod-plan
repo:<organization>/<repository>:environment:prod-apply
```

Use:

- issuer: `https://token.actions.githubusercontent.com`
- audience: `api://AzureADTokenExchange`

Grant the identities:

- `Storage Blob Data Contributor` at the Terraform-state container scope; and
- only the Azure management-plane roles required to plan or apply the selected landing-zone stack.

The runner VM itself does not need access to client secrets. The workflow requests a short-lived OIDC token for each job.

For a workflow that runs from `main` without a GitHub environment, use this federated credential subject instead:

```text
repo:<organization>/<repository>:ref:refs/heads/main
```

## 13. Configure GitHub settings

The current temporary workflow can use repository-level Actions secrets and variables. Under **Repository settings → Secrets and variables → Actions**, configure the values documented in [terraform-remote-backend.md](terraform-remote-backend.md), including the OIDC identity, tenant, target subscription, state account, state container, and state subscription.

Repository-level configuration does not provide deployment approvals. Keep the workflow restricted to `main`, require pull-request review for workflow changes, and restrict which repositories can use the runner.

When GitHub environment permissions become available, create `test-plan`, `test-apply`, `prod-plan`, and `prod-apply`. Use environment-specific federated credentials, require reviewers for apply environments, and add deployment branch or tag restrictions, especially for production.

## 14. Test the runner safely

First confirm that GitHub can assign a job to the runner with a temporary manually dispatched workflow:

```yaml
name: Self-hosted runner test

on:
  workflow_dispatch:

jobs:
  verify:
    runs-on: [self-hosted, linux, terraform-private]
    steps:
      - uses: actions/checkout@v4
      - name: Verify runner
        run: |
          hostname
          whoami
          pwd
          az version
```

Remove the temporary workflow after validation. Then manually dispatch the private-backend connectivity workflow from `main`. The job should:

1. be assigned to the intended self-hosted runner;
2. install Terraform;
3. initialize the private Azure Storage backend through OIDC;
4. validate the configuration; and
5. execute the requested plan or temporary deployment test.

If the job remains queued, confirm the runner is online and has all required labels. If backend initialization fails:

- timeout: check NSG, firewall, routing, proxy, and private endpoint status;
- DNS error or public IP resolution: check private DNS zone links and custom DNS forwarding;
- HTTP 403: check the OIDC federated credential and `Storage Blob Data Contributor` assignment;
- OIDC subject mismatch: confirm the federated credential environment subject exactly matches the job environment.

Only enable `apply` after reviewing a successful plan and confirming that the protected apply environment requires approval.

## 15. Troubleshoot the runner

Check the generated service status from `/opt/actions-runner`:

```bash
sudo ./svc.sh status
```

Verify outbound GitHub connectivity:

```bash
curl -I https://github.com
curl -I https://api.github.com
```

If the job remains queued, verify that the runner is online and that it has every label listed by `runs-on`. If the service is online but does not accept work, inspect the systemd unit reported by `svc.sh status` with `journalctl`.

For network failures, check the subnet NSG, route table, Azure Firewall or proxy, private endpoint status, and private DNS zone link. Do not solve private-backend failures by enabling public access to the state storage account.

## 16. Harden and operate the runner

- Treat a persistent runner as a privileged automation host.
- Restrict workflows that can target it through runner groups and repository permissions.
- Require pull-request approval and CODEOWNERS review for workflow changes.
- Do not run untrusted fork pull requests on it.
- Keep the runner service account non-root and avoid credential persistence.
- Patch the OS, runner application, CA certificates, and security agent regularly.
- Forward runner and OS logs to the approved monitoring platform.
- Monitor disk consumption under `_work` and remove stale workspaces safely.
- Rotate or replace the VM using an immutable image where possible.
- Prefer ephemeral runners for stronger job isolation in mature production environments.
- Keep at least one additional runner available if deployment availability is required; state locking protects concurrent Terraform runs.

## 17. Remove a runner

Before deleting or rebuilding the VM:

1. Disable or drain the runner so it accepts no new jobs.
2. Wait for active jobs to complete.
3. From `/opt/actions-runner`, stop and uninstall the service with `sudo ./svc.sh stop` and `sudo ./svc.sh uninstall`.
4. Remove the runner in GitHub or run `./config.sh remove` as `github-runner` with a newly generated removal token.
5. Delete the VM and revoke any VM-specific access.

Never reuse a runner work disk without following the organization's secure disposal process.

## References

- [Adding self-hosted runners](https://docs.github.com/en/actions/how-tos/manage-runners/self-hosted-runners/add-runners)
- [Configuring the self-hosted runner application as a service](https://docs.github.com/en/actions/how-tos/manage-runners/self-hosted-runners/configure-the-application)
- [GitHub Actions self-hosted runner communication requirements](https://docs.github.com/en/actions/reference/runners/self-hosted-runners)
- [Install Azure CLI on Linux](https://learn.microsoft.com/cli/azure/install-azure-cli-linux)
