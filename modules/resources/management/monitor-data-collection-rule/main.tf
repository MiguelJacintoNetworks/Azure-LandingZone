resource "azurerm_monitor_data_collection_rule" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "Windows"
  description         = var.description
  tags                = var.tags

  destinations {
    log_analytics {
      workspace_resource_id = var.log_analytics_workspace_resource_id
      name                  = "log_analytics"
    }
  }

  data_flow {
    streams      = ["Microsoft-Perf"]
    destinations = ["log_analytics"]
  }

  data_flow {
    streams      = ["Microsoft-Event"]
    destinations = ["log_analytics"]
  }

  data_sources {
    performance_counter {
      name                          = "performance_counters"
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = var.performance_counter_sampling_frequency_in_seconds
      counter_specifiers            = var.performance_counter_specifiers
    }

    windows_event_log {
      name           = "windows_event_logs"
      streams        = ["Microsoft-Event"]
      x_path_queries = var.windows_event_log_x_path_queries
    }
  }
}