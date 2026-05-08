output "id" {
  description = "RESOURCE ID OF THE RECOVERY SERVICES VAULT."
  value       = azapi_resource.this.id
}

output "name" {
  description = "NAME OF THE RECOVERY SERVICES VAULT."
  value       = azapi_resource.this.name
}