output "bastion_dns_name" {
  description = "DNS NAME OF THE DEPLOYED BASTION HOST."
  value       = module.bastion.dns_name
}

output "bastion_public_ip_address" {
  description = "PUBLIC IP ADDRESS OF THE DEPLOYED BASTION HOST."
  value       = module.bastion_public_ip.ip_address
}

output "firewall_private_ip_address" {
  description = "PRIVATE IP ADDRESS OF THE DEPLOYED AZURE FIREWALL."
  value       = module.firewall.private_ip_address
}

output "key_vault_id" {
  description = "RESOURCE ID OF THE DEPLOYED KEY VAULT."
  value       = module.key_vault.id
}

output "key_vault_name" {
  description = "NAME OF THE DEPLOYED KEY VAULT."
  value       = module.key_vault.name
}

output "key_vault_uri" {
  description = "VAULT URI OF THE DEPLOYED KEY VAULT."
  value       = module.key_vault.vault_uri
}

output "log_analytics_workspace_id" {
  description = "RESOURCE ID OF THE DEPLOYED LOG ANALYTICS WORKSPACE."
  value       = module.log_analytics_workspace.id
}

output "management_virtual_machine_id" {
  description = "RESOURCE ID OF THE DEPLOYED MANAGEMENT VIRTUAL MACHINE."
  value       = module.management_virtual_machine.id
}

output "management_virtual_machine_name" {
  description = "NAME OF THE DEPLOYED MANAGEMENT VIRTUAL MACHINE."
  value       = module.management_virtual_machine.name
}

output "management_virtual_machine_private_ip" {
  description = "PRIVATE IP ADDRESS OF THE DEPLOYED MANAGEMENT VIRTUAL MACHINE."
  value       = module.management_virtual_machine_network_interface.private_ip
}

output "recovery_services_vault_id" {
  description = "RESOURCE ID OF THE DEPLOYED RECOVERY SERVICES VAULT."
  value       = module.recovery_services_vault.id
}

output "resource_group_names" {
  description = "NAMES OF THE DEPLOYED RESOURCE GROUPS."
  value = {
    hub        = module.hub_resource_group.name
    management = module.management_resource_group.name
    monitoring = module.monitoring_resource_group.name
    workload   = module.workload_resource_group.name
  }
}

output "storage_account_id" {
  description = "RESOURCE ID OF THE DEPLOYED STORAGE ACCOUNT."
  value       = module.workload_storage_account.id
}

output "storage_account_name" {
  description = "NAME OF THE DEPLOYED STORAGE ACCOUNT."
  value       = module.workload_storage_account.name
}

output "virtual_network_ids" {
  description = "RESOURCE IDS OF THE DEPLOYED VIRTUAL NETWORKS."
  value = {
    hub        = module.hub_virtual_network.id
    management = module.management_virtual_network.id
    workload   = module.workload_virtual_network.id
  }
}

output "virtual_network_names" {
  description = "NAMES OF THE DEPLOYED VIRTUAL NETWORKS."
  value = {
    hub        = module.hub_virtual_network.name
    management = module.management_virtual_network.name
    workload   = module.workload_virtual_network.name
  }
}

output "platform_sentinel_storage_container_name" {
  description = "NAME OF THE PLATFORM SENTINEL STORAGE CONTAINER."
  value       = module.platform_sentinel_storage_container.name
}

output "platform_sentinel_storage_container_id" {
  description = "RESOURCE ID OF THE PLATFORM SENTINEL STORAGE CONTAINER."
  value       = module.platform_sentinel_storage_container.id
}

output "platform_sentinel_extension_id" {
  description = "RESOURCE ID OF THE PLATFORM SENTINEL CUSTOM SCRIPT EXTENSION."
  value       = var.enable_platform_sentinel_extension ? module.management_virtual_machine_platform_sentinel_extension[0].id : null
}