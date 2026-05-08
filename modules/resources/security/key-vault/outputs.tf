output "name" {
  description = "NAME OF THE KEY VAULT."
  value       = azurerm_key_vault.this.name
}

output "id" {
  description = "RESOURCE ID OF THE KEY VAULT."
  value       = azurerm_key_vault.this.id
}

output "vault_uri" {
  description = "VAULT URI OF THE KEY VAULT."
  value       = azurerm_key_vault.this.vault_uri
}