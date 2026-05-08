output "name" {
  description = "NAME OF THE KEY VAULT SECRET."
  value       = azurerm_key_vault_secret.this.name
}

output "id" {
  description = "RESOURCE ID OF THE KEY VAULT SECRET."
  value       = azurerm_key_vault_secret.this.id
}

output "version" {
  description = "VERSION OF THE KEY VAULT SECRET."
  value       = azurerm_key_vault_secret.this.version
}