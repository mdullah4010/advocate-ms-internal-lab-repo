# Internal hub virtual network

This Terraform root deploys an initial hub virtual network into the internal Azure subscription. It creates:

- a dedicated connectivity resource group;
- one hub virtual network;
- configurable hub subnets;
- optional custom DNS server settings; and
- standard resource tags.

The example includes reserved subnet names and Azure-compliant minimum sizes for Azure Firewall, VPN/ExpressRoute Gateway, and Azure Bastion. Remove services that are not part of the initial test before deployment.

## Temporary GitHub Actions test

This test branch uses local Terraform state and the GitHub-hosted runner defined in `.github/workflows/terraform-connectivity-local-test.yml`. It is intended only to prove that connectivity resources can be created and deleted.

1. Review `terraform/environments/test/connectivity.tfvars`, especially names and non-overlapping CIDR ranges.
2. Configure the `test-apply` GitHub environment with `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, and `AZURE_SUBSCRIPTION_ID` secrets.
3. Configure the Azure identity with a federated credential whose subject is `repo:<organization>/<repository>:environment:test-apply`.
4. Grant that identity only the Azure role required to create the test resources in the target subscription or resource group.
5. Open **Actions**, select **Temporary Connectivity Deployment Test**, choose this branch, and dispatch the workflow.
6. Confirm that apply, Azure verification, and destroy all succeed.

Plan, apply, verification, and destroy run in one job because local state exists only in the runner workspace. The workflow always attempts cleanup. If cleanup fails, it retains an emergency state artifact for one day; treat that artifact as sensitive and use it immediately to recover and destroy remaining resources.

Do not use local state for a persistent environment. Restore the Azure Storage backend before merging connectivity deployment code into the main deployment branch.

Do not connect this test hub to production, configure peering, or advertise routes until the address space has been approved by the network team.
