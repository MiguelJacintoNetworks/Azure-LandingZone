output "name" {
  description = "NAME OF THE STORAGE ACCOUNT."
  value       = azurerm_storage_account.this.name
}

output "id" {
  description = "RESOURCE ID OF THE STORAGE ACCOUNT."
  value       = azurerm_storage_account.this.id
}

output "primary_blob_endpoint" {
  description = "PRIMARY BLOB ENDPOINT OF THE STORAGE ACCOUNT."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "blob_service_resource_id" {
  description = "RESOURCE ID OF THE DEFAULT BLOB SERVICE OF THE STORAGE ACCOUNT."
  value       = "${azurerm_storage_account.this.id}/blobServices/default"
}