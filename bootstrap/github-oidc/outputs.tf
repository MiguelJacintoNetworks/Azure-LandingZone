output "azure_client_id" {
  description = "CLIENT ID FOR GITHUB ACTIONS."
  value       = azuread_application.github_actions.client_id
}

output "azure_tenant_id" {
  description = "TENANT ID."
  value       = data.azurerm_client_config.current.tenant_id
}

output "azure_subscription_id" {
  description = "SUBSCRIPTION ID."
  value       = data.azurerm_client_config.current.subscription_id
}