# Internal hub virtual network

This Terraform root deploys an initial hub virtual network into the internal Azure subscription. It creates:

- a dedicated connectivity resource group;
- one hub virtual network;
- configurable hub subnets;
- optional custom DNS server settings; and
- standard resource tags.

The example includes reserved subnet names and Azure-compliant minimum sizes for Azure Firewall, VPN/ExpressRoute Gateway, and Azure Bastion. Remove services that are not part of the initial test before deployment.

## Temporary GitHub Actions remote-backend test

The workflow in `.github/workflows/terraform-connectivity-sh-runner-remote-test.yml` uses the private Azure Storage backend and a self-hosted runner. It deploys, verifies, and destroys test resources from one manually dispatched `main` branch job.

1. Review `envs/test/connectivity.tfvars`, especially resource names and non-overlapping CIDR ranges.
2. Confirm that the self-hosted Linux runner is online with the `terraform-private` label and resolves the state storage hostname to its private endpoint address.
3. Configure `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, and `AZURE_SUBSCRIPTION_ID` as GitHub Actions secrets.
4. Configure `TFSTATE_RESOURCE_GROUP`, `TFSTATE_STORAGE_ACCOUNT`, `TFSTATE_CONTAINER`, and `TFSTATE_SUBSCRIPTION_ID` as GitHub Actions variables.
5. Configure the Azure identity with a federated credential whose subject matches the `main` branch token.
6. Grant the identity `Storage Blob Data Contributor` on the state container and only the management-plane role required to create the test resources.
7. Open **Actions**, select **Temporary Connectivity Deployment Test using Self-hosted Runner with Terraform Remote Backend**, choose `main`, enter `DEPLOY-AND-DESTROY`, and dispatch the workflow.
8. Confirm that remote initialization, plan, apply, Azure and state verification, and destroy all succeed.

The dedicated state key is `advocate/test/connectivity-remote-test.tfstate`. Cleanup always runs after successful backend initialization. If cleanup fails, use that remote state immediately to investigate and destroy any remaining resources; never edit or delete the state blob manually.

Do not connect this test hub to production, configure peering, or advertise routes until the address space has been approved by the network team.
