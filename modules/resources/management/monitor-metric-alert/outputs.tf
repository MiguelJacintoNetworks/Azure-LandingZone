output "id" {
  description = "RESOURCE ID OF THE METRIC ALERT."
  value       = azurerm_monitor_metric_alert.this.id
}

output "name" {
  description = "NAME OF THE METRIC ALERT."
  value       = azurerm_monitor_metric_alert.this.name
}