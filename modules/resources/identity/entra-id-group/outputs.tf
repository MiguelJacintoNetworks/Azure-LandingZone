output "id" {
  description = "RESOURCE ID OF THE MICROSOFT ENTRA ID GROUP."
  value       = msgraph_resource.group.id
}

output "display_name" {
  description = "DISPLAY NAME OF THE MICROSOFT ENTRA ID GROUP."
  value       = var.display_name
}