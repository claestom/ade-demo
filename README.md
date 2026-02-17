# ade-demo

Azure Deployment Environments demo catalog repository.

## Catalog structure

This repo includes one ADE environment definition:

- `Environment-Definitions/BicepTemplates/FunctionStorageLogs`
- `Environment-Definitions/BicepTemplates/FunctionStorageLogsProd`

## Environment definition

`FunctionStorageLogs` deploys:

- Azure Storage Account
- Azure Function App (Consumption)
- Azure Log Analytics Workspace

Defaults are set to low-cost options:

- Function plan: `Y1` (Consumption)
- Storage SKU: `Standard_LRS`
- Log Analytics SKU: `PerGB2018`
- Log retention: `30` days

## User-configurable options

Through `environment.yaml`, developers can override a few values:

- `location`
- `namePrefix`
- `functionRuntime` (`node`, `python`, `dotnet-isolated`, `powershell`)
- `storageSku` (`Standard_LRS`, `Standard_GRS`)

`logRetentionInDays` is fixed at `30` in the Bicep template (integer), and is not user-editable.

`FunctionStorageLogsProd` deploys the same resources with a stricter profile and fewer editable parameters.

Fixed defaults in `FunctionStorageLogsProd`:

- Runtime: `dotnet-isolated`
- Storage SKU: `Standard_GRS`
- Log retention: `90` days

User-editable parameters in `FunctionStorageLogsProd`:

- `location`
- `namePrefix`

## Add this repo as an ADE catalog

1. In your dev center or project, open **Catalogs**.
2. Add this GitHub repository as a catalog.
3. Set folder path to `Environment-Definitions/BicepTemplates`.
4. Sync the catalog.
5. Use `FunctionStorageLogs` (flexible demo) or `FunctionStorageLogsProd` (stricter profile) in the developer portal.
