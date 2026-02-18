# ade-demo

Azure Deployment Environments (ADE) demo catalog.

## Repository structure

- `Environment-Definitions/BicepTemplates` - active ADE Bicep definitions
- `Environment-Definitions/ARMTemplates` - placeholder for ARM definitions
- `Tasks` - placeholder for Dev Box task definitions

## Catalog definitions

This catalog contains two Bicep-based environment definitions:

- `Environment-Definitions/BicepTemplates/FunctionStorageLogsV2`
- `Environment-Definitions/BicepTemplates/FunctionStorageLogsProdV2`

Each definition deploys:

- Azure Storage Account
- Azure Function App (Consumption plan)
- Azure Log Analytics Workspace

## FunctionStorageLogsV2

Flexible profile with low-cost defaults:

- Function plan: `Y1` (Consumption)
- Storage SKU: `Standard_LRS`
- Log Analytics SKU: `PerGB2018`
- Log retention: `30` days

User-configurable parameters:

- `namePrefix`
- `functionRuntime` (`node`, `python`, `dotnet-isolated`, `powershell`)
- `storageSku` (`Standard_LRS`, `Standard_GRS`)

`logRetentionInDays` is fixed at integer value `30` and is not user-editable.

## FunctionStorageLogsProdV2

Stricter profile with fewer editable inputs.

Fixed settings:

- Runtime: `dotnet-isolated`
- Storage SKU: `Standard_GRS`
- Log retention: `90` days

User-configurable parameters:

- `namePrefix`

## Use as ADE catalog

1. In your dev center or project, open **Catalogs**.
2. Add this GitHub repository as a catalog.
3. Set folder path to `Environment-Definitions/BicepTemplates`.
4. Sync the catalog.
5. In the developer portal, choose `FunctionStorageLogsV2` or `FunctionStorageLogsProdV2`.
