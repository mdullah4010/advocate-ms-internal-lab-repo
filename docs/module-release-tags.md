# Module release tags

This repository uses module-qualified Git tags so modules in the same repository can be versioned independently. A Git tag identifies a commit for the entire repository, but consumers select one module from that commit by using its directory in the Terraform source URL.

## Tag naming

Use the following format:

```text
avm-<module-name>-v<major>.<minor>.<patch>
or
custom-<module-name>-v<major>.<minor>.<patch>
```

Examples:

```text
avm-log-analytics-workspace-v1.0.0
avm-key-vault-v1.2.0
avm-virtual-network-v2.0.0
```

Choose the version according to semantic versioning:

- Increment `patch` for backward-compatible fixes.
- Increment `minor` for backward-compatible functionality.
- Increment `major` for breaking changes.

Module-qualified tags extend the repository-wide release-tag convention in the [Advocate Health DevOps Naming Convention Standard](Advocate_Health_DevOps_Naming_Convention_Standard_v1.1.md#93-branches-commits-and-pull-requests).

## Prerequisites

Before creating a tag:

1. Merge the approved module changes into `main`.
2. Confirm the module deployment test workflow completed successfully.
3. Add the new version and a summary of changes to the module README's `Changelog` section, with the newest version first.
4. Confirm the remaining module README and interface documentation are current.
5. Select a version that has not already been published for the module.

Do not tag a feature branch or an unreviewed local commit.

## Create and publish a tag

Run the following commands from the repository root. Replace the module name and version as needed.

```powershell
$module = "log-analytics-workspace"
$version = "1.0.0"
$tag = "avm-${module}-v${version}"

git fetch origin main --tags
git tag --list "avm-${module}-v*"
```

Create an annotated tag against the current remote `main` commit:

```powershell
git tag -a $tag origin/main -m "Release ${module} v${version}"
```

Inspect the tag and confirm it points to the intended release commit:

```powershell
git show $tag
```

Publish the tag to GitHub:

```powershell
git push origin $tag
```

## Create a GitHub Release

A GitHub Release is optional, but recommended for recording release notes and making published versions easier to discover.

```powershell
gh release create $tag `
  --title "${module} v${version}" `
  --generate-notes
```

Review generated notes and call out breaking changes, migration requirements, and important input or output changes.

## Consume a tagged module

Use the module directory after `//` and the module-qualified tag in the `ref` query parameter:

```hcl
module "log_analytics_workspace" {
  source = "git::https://github.com/ah-enterprise-cloud-services/terraform-azure-modules.git//avm/log-analytics-workspace?ref=avm-log-analytics-workspace-v1.0.0"

  # Module inputs
}
```

Run `terraform init -upgrade` after changing the tag reference so Terraform downloads the selected version.

## Publish a later version

Do not move, overwrite, or reuse a published tag. Merge the new change into `main`, rerun validation, and publish a new version such as:

```text
avm-log-analytics-workspace-v1.0.1
```

## Correct an unpublished mistake

If an incorrect tag has not been consumed or announced, remove it locally and remotely, correct the release commit, and create it again:

```powershell
git tag -d $tag
git push origin --delete $tag
```

If the tag has already been published for consumers, leave it immutable and issue a new patch version instead.