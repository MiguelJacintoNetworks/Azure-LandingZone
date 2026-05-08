resource "azurerm_monitor_scheduled_query_rules_alert_v2" "this" {
  name                 = var.name
  resource_group_name  = var.resource_group_name
  location             = var.location
  scopes               = var.scopes
  description          = var.description
  severity             = var.severity
  enabled              = var.enabled
  evaluation_frequency = var.evaluation_frequency
  window_duration      = var.window_duration
  tags                 = var.tags

  criteria {
    query                   = var.query
    time_aggregation_method = var.time_aggregation_method
    operator                = var.operator
    threshold               = var.threshold

    failing_periods {
      number_of_evaluation_periods             = var.number_of_evaluation_periods
      minimum_failing_periods_to_trigger_alert = var.minimum_failing_periods_to_trigger_alert
    }
  }

  action {
    action_groups = [var.action_group_id]
  }
}