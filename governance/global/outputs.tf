output "current_subscription_display_name" {
  description = "CURRENT AZURE SUBSCRIPTION DISPLAY NAME RESOLVED BY THE PROVIDER."
  value       = data.azurerm_subscription.current.display_name
}

output "current_subscription_id" {
  description = "CURRENT AZURE SUBSCRIPTION ID RESOLVED BY THE PROVIDER."
  value       = data.azurerm_client_config.current.subscription_id
}

output "current_tenant_id" {
  description = "CURRENT AZURE TENANT ID RESOLVED BY THE PROVIDER."
  value       = data.azurerm_client_config.current.tenant_id
}

output "defender_for_servers_pricing_id" {
  description = "RESOURCE ID OF THE DEFENDER FOR SERVERS PRICING CONFIGURATION."
  value       = length(module.defender_for_servers_pricing) > 0 ? values(module.defender_for_servers_pricing)[0].id : null
}

output "defender_for_servers_pricing_resource_type" {
  description = "RESOURCE TYPE OF THE DEFENDER FOR SERVERS PRICING CONFIGURATION."
  value       = length(module.defender_for_servers_pricing) > 0 ? values(module.defender_for_servers_pricing)[0].resource_type : null
}

output "defender_security_contact_email" {
  description = "EMAIL ADDRESS OF THE DEFENDER FOR CLOUD SECURITY CONTACT."
  value       = length(module.defender_security_contact) > 0 ? values(module.defender_security_contact)[0].email : null
}

output "defender_security_contact_id" {
  description = "RESOURCE ID OF THE DEFENDER FOR CLOUD SECURITY CONTACT."
  value       = length(module.defender_security_contact) > 0 ? values(module.defender_security_contact)[0].id : null
}

output "entra_group_ids" {
  description = "RESOURCE IDS OF THE MICROSOFT ENTRA GROUPS."
  value = var.enable_entra_groups ? {
    for key, group in module.entra_groups : key => group.id
  } : {}
}

output "entra_group_names" {
  description = "DISPLAY NAMES OF THE MICROSOFT ENTRA GROUPS."
  value = var.enable_entra_groups ? {
    for key, group in module.entra_groups : key => group.display_name
  } : {}
}

output "policy_assignment_id" {
  description = "RESOURCE ID OF THE GOVERNANCE POLICY ASSIGNMENT."
  value       = module.policy_assignment_baseline.id
}

output "policy_assignment_name" {
  description = "NAME OF THE GOVERNANCE POLICY ASSIGNMENT."
  value       = module.policy_assignment_baseline.name
}

output "policy_definition_ids" {
  description = "RESOURCE IDS OF THE CUSTOM POLICY DEFINITIONS."
  value = {
    allowed_locations                 = azurerm_policy_definition.allowed_locations.id
    allowed_locations_resource_groups = azurerm_policy_definition.allowed_locations_resource_groups.id
    key_vault_public_network_access   = azurerm_policy_definition.audit_key_vault_public_network_access.id
    required_resource_group_tags      = azurerm_policy_definition.audit_required_resource_group_tags.id
    required_resource_tags            = azurerm_policy_definition.audit_required_resource_tags.id
    storage_public_network_access     = azurerm_policy_definition.audit_storage_public_network_access.id
  }
}

output "policy_definition_names" {
  description = "NAMES OF THE CUSTOM POLICY DEFINITIONS."
  value = {
    allowed_locations                 = azurerm_policy_definition.allowed_locations.name
    allowed_locations_resource_groups = azurerm_policy_definition.allowed_locations_resource_groups.name
    key_vault_public_network_access   = azurerm_policy_definition.audit_key_vault_public_network_access.name
    required_resource_group_tags      = azurerm_policy_definition.audit_required_resource_group_tags.name
    required_resource_tags            = azurerm_policy_definition.audit_required_resource_tags.name
    storage_public_network_access     = azurerm_policy_definition.audit_storage_public_network_access.name
  }
}

output "policy_set_definition_id" {
  description = "RESOURCE ID OF THE GOVERNANCE POLICY SET DEFINITION."
  value       = module.policy_set_definition_baseline.id
}

output "policy_set_definition_name" {
  description = "NAME OF THE GOVERNANCE POLICY SET DEFINITION."
  value       = module.policy_set_definition_baseline.name
}

output "role_assignment_ids" {
  description = "RESOURCE IDS OF THE ROLE ASSIGNMENTS CREATED FOR THE IDENTITY BASELINE."
  value = var.enable_entra_groups ? {
    for key, assignment in module.role_assignments : key => assignment.id
  } : {}
}

output "target_scope_id" {
  description = "TARGET GOVERNANCE SCOPE ID."
  value       = local.target_scope_id
}

output "target_subscription_id" {
  description = "TARGET SUBSCRIPTION ID USED FOR GOVERNANCE DEPLOYMENT."
  value       = local.target_subscription_id
}