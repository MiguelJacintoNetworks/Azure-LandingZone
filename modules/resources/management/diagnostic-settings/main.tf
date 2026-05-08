resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = var.name
  target_resource_id         = var.target_resource_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = toset(var.enabled_logs)

    content {
      category = enabled_log.value
    }
  }

  dynamic "enabled_metric" {
    for_each = toset(var.enabled_metrics)

    content {
      category = enabled_metric.value
    }
  }
}