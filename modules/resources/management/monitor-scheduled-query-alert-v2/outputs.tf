output "id" {
  description = "RESOURCE ID OF THE SCHEDULED QUERY ALERT."
  value       = azurerm_monitor_scheduled_query_rules_alert_v2.this.id
}

output "name" {
  description = "NAME OF THE SCHEDULED QUERY ALERT."
  value       = azurerm_monitor_scheduled_query_rules_alert_v2.this.name
}