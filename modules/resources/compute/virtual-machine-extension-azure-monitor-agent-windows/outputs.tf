output "id" {
  description = "RESOURCE ID OF THE VIRTUAL MACHINE EXTENSION."
  value       = azurerm_virtual_machine_extension.this.id
}

output "name" {
  description = "NAME OF THE VIRTUAL MACHINE EXTENSION."
  value       = azurerm_virtual_machine_extension.this.name
}