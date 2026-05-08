module "bastion_diagnostic_settings" {
  source = "../../modules/resources/management/diagnostic-settings"

  enabled_logs               = local.diagnostic_logs.bastion
  enabled_metrics            = local.diagnostic_metrics.bastion
  log_analytics_workspace_id = module.log_analytics_workspace.id
  name                       = local.names.bastion_diagnostic_settings
  target_resource_id         = module.bastion.id
}

module "firewall_diagnostic_settings" {
  source = "../../modules/resources/management/diagnostic-settings"

  enabled_logs               = local.diagnostic_logs.firewall
  enabled_metrics            = local.diagnostic_metrics.firewall
  log_analytics_workspace_id = module.log_analytics_workspace.id
  name                       = local.names.firewall_diagnostic_settings
  target_resource_id         = module.firewall.id
}

module "key_vault_diagnostic_settings" {
  source = "../../modules/resources/management/diagnostic-settings"

  enabled_logs               = local.diagnostic_logs.key_vault
  enabled_metrics            = local.diagnostic_metrics.key_vault
  log_analytics_workspace_id = module.log_analytics_workspace.id
  name                       = local.names.key_vault_diagnostic_settings
  target_resource_id         = module.key_vault.id
}

module "log_analytics_workspace" {
  source = "../../modules/resources/management/log-analytics-workspace"

  location            = var.location
  name                = local.names.log_analytics_workspace
  resource_group_name = module.monitoring_resource_group.name
  retention_in_days   = var.log_analytics_retention_in_days
  sku                 = var.log_analytics_sku
  tags                = local.common_tags
}

module "management_virtual_machine_action_group" {
  source = "../../modules/resources/management/monitor-action-group"

  email_receiver_address = var.alert_email_address
  email_receiver_name    = var.alert_email_receiver_name
  name                   = local.names.action_group_management_vm
  resource_group_name    = module.monitoring_resource_group.name
  short_name             = "mgmtag"
  tags                   = local.common_tags
}

module "management_virtual_machine_cpu_metric_alert" {
  source = "../../modules/resources/management/monitor-metric-alert"

  action_group_id     = module.management_virtual_machine_action_group.id
  aggregation         = "Average"
  description         = "ALERTS WHEN MANAGEMENT VM CPU UTILIZATION IS HIGH."
  enabled             = true
  frequency           = var.management_virtual_machine_cpu_alert_evaluation_frequency
  metric_name         = "Percentage CPU"
  metric_namespace    = "Microsoft.Compute/virtualMachines"
  name                = local.names.management_virtual_machine_cpu_alert
  operator            = "GreaterThan"
  resource_group_name = module.monitoring_resource_group.name
  scopes              = [module.management_virtual_machine.id]
  severity            = var.management_virtual_machine_cpu_alert_severity
  tags                = local.common_tags
  threshold           = var.management_virtual_machine_cpu_alert_threshold
  window_size         = var.management_virtual_machine_cpu_alert_window_size
}

module "management_virtual_machine_data_collection_rule" {
  source = "../../modules/resources/management/monitor-data-collection-rule"

  description                                       = "DATA COLLECTION RULE FOR THE MANAGEMENT WINDOWS VIRTUAL MACHINE."
  location                                          = var.location
  log_analytics_workspace_resource_id               = module.log_analytics_workspace.id
  name                                              = local.names.management_data_collection_rule
  performance_counter_sampling_frequency_in_seconds = local.monitoring_config.management_vm.performance_counter_sampling_frequency_in_seconds
  performance_counter_specifiers                    = local.monitoring_config.management_vm.performance_counter_specifiers
  resource_group_name                               = module.monitoring_resource_group.name
  tags                                              = local.common_tags
  windows_event_log_x_path_queries                  = local.monitoring_config.management_vm.windows_event_log_x_path_queries
}

module "management_virtual_machine_data_collection_rule_association" {
  source = "../../modules/resources/management/monitor-data-collection-rule-association"

  data_collection_rule_id = module.management_virtual_machine_data_collection_rule.id
  description             = "ASSOCIATES THE MANAGEMENT WINDOWS VIRTUAL MACHINE WITH ITS DATA COLLECTION RULE."
  name                    = local.names.management_data_collection_rule_association
  target_resource_id      = module.management_virtual_machine.id

  depends_on = [
    module.management_virtual_machine_extension
  ]
}

module "management_virtual_machine_heartbeat_scheduled_query_alert" {
  source = "../../modules/resources/management/monitor-scheduled-query-alert-v2"

  action_group_id                          = module.management_virtual_machine_action_group.id
  description                              = "ALERTS WHEN THE MANAGEMENT VM STOPS SENDING HEARTBEAT DATA."
  enabled                                  = true
  evaluation_frequency                     = var.management_virtual_machine_heartbeat_alert_evaluation_frequency
  location                                 = var.location
  minimum_failing_periods_to_trigger_alert = 1
  name                                     = local.names.management_virtual_machine_heartbeat_alert
  number_of_evaluation_periods             = 1
  operator                                 = "LessThan"
  query                                    = <<-QUERY
Heartbeat
| where Computer == "${module.management_virtual_machine.name}"
| where TimeGenerated > ago(10m)
| summarize HeartbeatCount = count()
QUERY
  resource_group_name                      = module.monitoring_resource_group.name
  scopes                                   = [module.log_analytics_workspace.id]
  severity                                 = var.management_virtual_machine_heartbeat_alert_severity
  tags                                     = local.common_tags
  threshold                                = var.management_virtual_machine_heartbeat_alert_threshold
  time_aggregation_method                  = "Count"
  window_duration                          = var.management_virtual_machine_heartbeat_alert_window_duration

  depends_on = [
    module.management_virtual_machine_data_collection_rule_association
  ]
}

module "management_virtual_machine_maintenance_assignment" {
  source = "../../modules/resources/management/maintenance-assignment"

  location                     = var.location
  maintenance_configuration_id = module.management_virtual_machine_maintenance_configuration.id
  virtual_machine_id           = module.management_virtual_machine.id
}

module "management_virtual_machine_maintenance_configuration" {
  source = "../../modules/resources/management/maintenance-configuration"

  duration                = var.maintenance_configuration_duration
  location                = var.location
  name                    = local.names.management_virtual_machine_maintenance
  reboot_setting          = var.maintenance_configuration_reboot_setting
  recur_every             = var.maintenance_configuration_recur_every
  resource_group_name     = module.monitoring_resource_group.name
  start_date_time         = var.maintenance_configuration_start_date_time
  tags                    = local.common_tags
  time_zone               = var.maintenance_configuration_time_zone
  windows_classifications = var.maintenance_configuration_windows_classifications
}

module "storage_diagnostic_settings" {
  source = "../../modules/resources/management/diagnostic-settings"

  enabled_logs               = local.diagnostic_logs.storage
  enabled_metrics            = []
  log_analytics_workspace_id = module.log_analytics_workspace.id
  name                       = local.names.storage_diagnostic_settings
  target_resource_id         = module.workload_storage_account.blob_service_resource_id
}