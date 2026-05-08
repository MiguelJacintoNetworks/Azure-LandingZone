resource "azapi_resource" "this" {
  type      = "Microsoft.RecoveryServices/vaults@2025-02-01"
  name      = var.name
  location  = var.location
  parent_id = var.resource_group_id
  tags      = var.tags

  body = {
    properties = {
      publicNetworkAccess = var.public_network_access

      securitySettings = {
        immutabilitySettings = {
          state = var.immutability_state
        }

        softDeleteSettings = {
          softDeleteState                 = var.soft_delete_state
          softDeleteRetentionPeriodInDays = var.soft_delete_retention_period_in_days
        }
      }
    }

    sku = {
      name = var.sku
    }
  }

  response_export_values = ["id", "name"]
}