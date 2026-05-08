resource "azurerm_policy_definition" "allowed_locations" {
  name         = local.names.policy_allowed_locations
  policy_type  = "Custom"
  mode         = "All"
  display_name = "ALLOWED LOCATIONS ${upper(var.environment)}"
  description  = "RESTRICTS RESOURCE DEPLOYMENTS TO APPROVED AZURE REGIONS."

  metadata = jsonencode({
    category    = "General"
    environment = var.environment
    version     = "1.0.0"
  })

  parameters = jsonencode({
    listOfAllowedLocations = {
      type = "Array"
      metadata = {
        displayName = "ALLOWED LOCATIONS"
        description = "THE LIST OF PERMITTED AZURE REGIONS."
      }
    }
    effect = {
      type = "String"
      metadata = {
        displayName = "EFFECT"
        description = "THE EFFECT USED WHEN A RESOURCE IS DEPLOYED OUTSIDE THE APPROVED LOCATIONS."
      }
      allowedValues = ["Audit", "Deny", "Disabled"]
      defaultValue  = "Deny"
    }
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field     = "type"
          notEquals = "Microsoft.Resources/subscriptions/resourceGroups"
        },
        {
          field     = "location"
          notEquals = "global"
        },
        {
          field = "location"
          notIn = "[parameters('listOfAllowedLocations')]"
        }
      ]
    }
    then = {
      effect = "[parameters('effect')]"
    }
  })
}

resource "azurerm_policy_definition" "allowed_locations_resource_groups" {
  name         = local.names.policy_allowed_rg_locations
  policy_type  = "Custom"
  mode         = "All"
  display_name = "ALLOWED LOCATIONS FOR RESOURCE GROUPS ${upper(var.environment)}"
  description  = "RESTRICTS RESOURCE GROUP CREATION TO APPROVED AZURE REGIONS."

  metadata = jsonencode({
    category    = "General"
    environment = var.environment
    version     = "1.0.0"
  })

  parameters = jsonencode({
    listOfAllowedLocations = {
      type = "Array"
      metadata = {
        displayName = "ALLOWED LOCATIONS"
        description = "THE LIST OF PERMITTED AZURE REGIONS FOR RESOURCE GROUPS."
      }
    }
    effect = {
      type = "String"
      metadata = {
        displayName = "EFFECT"
        description = "THE EFFECT USED WHEN A RESOURCE GROUP IS DEPLOYED OUTSIDE THE APPROVED LOCATIONS."
      }
      allowedValues = ["Audit", "Deny", "Disabled"]
      defaultValue  = "Deny"
    }
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Resources/subscriptions/resourceGroups"
        },
        {
          field = "location"
          notIn = "[parameters('listOfAllowedLocations')]"
        }
      ]
    }
    then = {
      effect = "[parameters('effect')]"
    }
  })
}

resource "azurerm_policy_definition" "audit_required_resource_tags" {
  name         = local.names.policy_audit_required_resource_tags
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "AUDIT REQUIRED TAGS ON RESOURCES ${upper(var.environment)}"
  description  = "AUDITS NON-COMPLIANT RESOURCES THAT ARE MISSING A REQUIRED TAG."

  metadata = jsonencode({
    category    = "Tags"
    environment = var.environment
    version     = "1.0.0"
  })

  parameters = jsonencode({
    tagName = {
      type = "String"
      metadata = {
        displayName = "TAG NAME"
        description = "THE REQUIRED TAG NAME."
      }
    }
    effect = {
      type = "String"
      metadata = {
        displayName = "EFFECT"
        description = "THE EFFECT USED WHEN A RESOURCE IS MISSING THE REQUIRED TAG."
      }
      allowedValues = ["Audit", "Deny", "Disabled"]
      defaultValue  = "Audit"
    }
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field     = "type"
          notEquals = "Microsoft.Resources/subscriptions/resourceGroups"
        },
        {
          field  = "[concat('tags[', parameters('tagName'), ']')]"
          exists = "false"
        }
      ]
    }
    then = {
      effect = "[parameters('effect')]"
    }
  })
}

resource "azurerm_policy_definition" "audit_required_resource_group_tags" {
  name         = local.names.policy_audit_required_rg_tags
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AUDIT REQUIRED TAGS ON RESOURCE GROUPS ${upper(var.environment)}"
  description  = "AUDITS NON-COMPLIANT RESOURCE GROUPS THAT ARE MISSING A REQUIRED TAG."

  metadata = jsonencode({
    category    = "Tags"
    environment = var.environment
    version     = "1.0.0"
  })

  parameters = jsonencode({
    tagName = {
      type = "String"
      metadata = {
        displayName = "TAG NAME"
        description = "THE REQUIRED TAG NAME."
      }
    }
    effect = {
      type = "String"
      metadata = {
        displayName = "EFFECT"
        description = "THE EFFECT USED WHEN A RESOURCE GROUP IS MISSING THE REQUIRED TAG."
      }
      allowedValues = ["Audit", "Deny", "Disabled"]
      defaultValue  = "Audit"
    }
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Resources/subscriptions/resourceGroups"
        },
        {
          field  = "[concat('tags[', parameters('tagName'), ']')]"
          exists = "false"
        }
      ]
    }
    then = {
      effect = "[parameters('effect')]"
    }
  })
}

resource "azurerm_policy_definition" "audit_storage_public_network_access" {
  name         = local.names.policy_audit_storage_public_access
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AUDIT STORAGE PUBLIC NETWORK ACCESS ${upper(var.environment)}"
  description  = "AUDITS STORAGE ACCOUNTS WHERE PUBLIC NETWORK ACCESS IS NOT DISABLED."

  metadata = jsonencode({
    category    = "Storage"
    environment = var.environment
    version     = "1.0.0"
  })

  parameters = jsonencode({
    effect = {
      type = "String"
      metadata = {
        displayName = "EFFECT"
        description = "THE EFFECT USED WHEN STORAGE PUBLIC NETWORK ACCESS IS ENABLED."
      }
      allowedValues = ["Audit", "Deny", "Disabled"]
      defaultValue  = "Audit"
    }
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Storage/storageAccounts"
        },
        {
          field     = "Microsoft.Storage/storageAccounts/publicNetworkAccess"
          notEquals = "Disabled"
        }
      ]
    }
    then = {
      effect = "[parameters('effect')]"
    }
  })
}

resource "azurerm_policy_definition" "audit_key_vault_public_network_access" {
  name         = local.names.policy_audit_key_vault_public_access
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AUDIT KEY VAULT PUBLIC NETWORK ACCESS ${upper(var.environment)}"
  description  = "AUDITS KEY VAULTS WHERE PUBLIC NETWORK ACCESS IS NOT DISABLED."

  metadata = jsonencode({
    category    = "Key Vault"
    environment = var.environment
    version     = "1.0.0"
  })

  parameters = jsonencode({
    effect = {
      type = "String"
      metadata = {
        displayName = "EFFECT"
        description = "THE EFFECT USED WHEN KEY VAULT PUBLIC NETWORK ACCESS IS ENABLED."
      }
      allowedValues = ["Audit", "Deny", "Disabled"]
      defaultValue  = "Audit"
    }
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.KeyVault/vaults"
        },
        {
          field     = "Microsoft.KeyVault/vaults/publicNetworkAccess"
          notEquals = "Disabled"
        }
      ]
    }
    then = {
      effect = "[parameters('effect')]"
    }
  })
}

module "policy_set_definition_baseline" {
  source = "../../modules/resources/governance/policy-set-definition"

  name         = local.names.policy_set_definition_baseline
  display_name = "LANDING ZONE ADMIN BASELINE ${upper(var.environment)}"
  description  = "BASELINE GOVERNANCE INITIATIVE FOR THE AZURE ADMINISTRATION LANDING ZONE."
  policy_type  = "Custom"

  metadata = jsonencode({
    category    = "Governance"
    environment = var.environment
    version     = "1.0.0"
  })

  policy_definitions = merge(
    {
      allowed_locations = {
        policy_definition_id = azurerm_policy_definition.allowed_locations.id
        reference_id         = "allowedLocations"
        parameter_values = jsonencode({
          listOfAllowedLocations = {
            value = var.allowed_locations
          }
          effect = {
            value = var.allowed_locations_effect
          }
        })
      }

      allowed_locations_resource_groups = {
        policy_definition_id = azurerm_policy_definition.allowed_locations_resource_groups.id
        reference_id         = "allowedLocationsForResourceGroups"
        parameter_values = jsonencode({
          listOfAllowedLocations = {
            value = var.allowed_locations
          }
          effect = {
            value = var.allowed_locations_effect
          }
        })
      }

      audit_storage_public_network_access = {
        policy_definition_id = azurerm_policy_definition.audit_storage_public_network_access.id
        reference_id         = "auditStoragePublicNetworkAccess"
        parameter_values = jsonencode({
          effect = {
            value = var.public_network_access_effect
          }
        })
      }

      audit_key_vault_public_network_access = {
        policy_definition_id = azurerm_policy_definition.audit_key_vault_public_network_access.id
        reference_id         = "auditKeyVaultPublicNetworkAccess"
        parameter_values = jsonencode({
          effect = {
            value = var.public_network_access_effect
          }
        })
      }
    },
    {
      for tag_name in local.normalized_required_tag_names :
      "audit_required_resource_tag_${tag_name}" => {
        policy_definition_id = azurerm_policy_definition.audit_required_resource_tags.id
        reference_id         = "auditRequiredResourceTag${replace(replace(title(tag_name), "_", ""), "-", "")}"
        parameter_values = jsonencode({
          tagName = {
            value = tag_name
          }
          effect = {
            value = var.tag_compliance_effect
          }
        })
      }
    },
    {
      for tag_name in local.normalized_required_tag_names :
      "audit_required_resource_group_tag_${tag_name}" => {
        policy_definition_id = azurerm_policy_definition.audit_required_resource_group_tags.id
        reference_id         = "auditRequiredResourceGroupTag${replace(replace(title(tag_name), "_", ""), "-", "")}"
        parameter_values = jsonencode({
          tagName = {
            value = tag_name
          }
          effect = {
            value = var.tag_compliance_effect
          }
        })
      }
    }
  )
}

module "policy_assignment_baseline" {
  source = "../../modules/resources/governance/policy-assignment"

  name                 = local.names.policy_assignment_baseline
  subscription_id      = local.target_subscription_id
  policy_definition_id = module.policy_set_definition_baseline.id
  display_name         = "LANDING ZONE ADMIN BASELINE ${upper(var.environment)}"
  description          = "ASSIGNS THE LANDING ZONE ADMIN GOVERNANCE BASELINE TO THE CURRENT SUBSCRIPTION."

  metadata = jsonencode({
    environment     = var.environment
    workload        = var.workload_name
    managed_by      = "terraform"
    subscription_id = local.target_subscription_id
  })
}