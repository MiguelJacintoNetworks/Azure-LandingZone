output "id" {
  description = "RESOURCE ID OF THE CUSTOM SCRIPT VIRTUAL MACHINE EXTENSION."
  value       = azurerm_virtual_machine_extension.this.id
}

output "name" {
  description = "NAME OF THE CUSTOM SCRIPT VIRTUAL MACHINE EXTENSION."
  value       = azurerm_virtual_machine_extension.this.name
}