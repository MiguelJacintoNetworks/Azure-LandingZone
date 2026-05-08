output "id" {
  description = "RESOURCE ID OF THE WINDOWS VIRTUAL MACHINE."
  value       = azurerm_windows_virtual_machine.this.id
}

output "name" {
  description = "NAME OF THE WINDOWS VIRTUAL MACHINE."
  value       = azurerm_windows_virtual_machine.this.name
}

output "principal_id" {
  description = "PRINCIPAL ID OF THE SYSTEM-ASSIGNED MANAGED IDENTITY."
  value       = try(azurerm_windows_virtual_machine.this.identity[0].principal_id, null)
}

output "tenant_id" {
  description = "TENANT ID OF THE SYSTEM-ASSIGNED MANAGED IDENTITY."
  value       = try(azurerm_windows_virtual_machine.this.identity[0].tenant_id, null)
}