output "id" {
  description = "RESOURCE ID OF THE MICROSOFT DEFENDER FOR CLOUD SECURITY CONTACT."
  value       = azurerm_security_center_contact.this.id
}

output "email" {
  description = "EMAIL ADDRESS OF THE MICROSOFT DEFENDER FOR CLOUD SECURITY CONTACT."
  value       = azurerm_security_center_contact.this.email
}