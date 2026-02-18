# Environment Definitions

This folder contains environment definitions for Azure Deployment Environments catalogs.

## Structure

- `BicepTemplates/` - Bicep-based environment definitions
- `ARMTemplates/` - ARM-based environment definitions (optional)

Use a subfolder per definition, including at minimum:

- `environment.yaml`
- IaC template file (for example `main.bicep`)
