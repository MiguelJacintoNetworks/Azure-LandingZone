alert_email_address       = "miguelmazda@gmail.com"
alert_email_receiver_name = "PRIMARYEMAIL"

backup_immutability_state                   = "Disabled"
backup_policy_backup_frequency              = "Daily"
backup_policy_backup_time                   = "23:00"
backup_policy_retention_daily_count         = 7
backup_public_network_access                = "Enabled"
backup_soft_delete_retention_period_in_days = 14
backup_soft_delete_state                    = "Enabled"

default_tags = {
  cost_center = "lab"
  domain      = "networking"
  owner       = "Miguel"
}

environment = "dev"

firewall_policy_sku                      = "Standard"
firewall_policy_threat_intelligence_mode = "Alert"
firewall_sku_name                        = "AZFW_VNet"
firewall_sku_tier                        = "Standard"

location = "eastus"

log_analytics_retention_in_days = 30
log_analytics_sku               = "PerGB2018"

maintenance_configuration_duration                = "03:00"
maintenance_configuration_reboot_setting          = "IfRequired"
maintenance_configuration_recur_every             = "Week Saturday"
maintenance_configuration_start_date_time         = "2024-01-01 02:00"
maintenance_configuration_time_zone               = "UTC"
maintenance_configuration_windows_classifications = ["Critical", "Security"]

management_allowed_destination_fqdns = [
  "www.google.com",
  "www.esamarante.edu.pt"
]

management_virtual_machine_bypass_platform_safety_checks_on_user_schedule_enabled = true
management_virtual_machine_cpu_alert_evaluation_frequency                         = "PT1M"
management_virtual_machine_cpu_alert_severity                                     = 2
management_virtual_machine_cpu_alert_threshold                                    = 80
management_virtual_machine_cpu_alert_window_size                                  = "PT5M"
management_virtual_machine_heartbeat_alert_evaluation_frequency                   = "PT5M"
management_virtual_machine_heartbeat_alert_severity                               = 1
management_virtual_machine_heartbeat_alert_threshold                              = 1
management_virtual_machine_heartbeat_alert_window_duration                        = "PT10M"
management_virtual_machine_patch_mode                                             = "AutomaticByPlatform"
management_virtual_machine_performance_counter_sampling_frequency_in_seconds      = 60
management_virtual_machine_performance_counter_specifiers = [
  "\\Processor(_Total)\\% Processor Time",
  "\\Memory\\Available MBytes",
  "\\LogicalDisk(_Total)\\% Free Space"
]
management_virtual_machine_reboot_setting = "IfRequired"
management_virtual_machine_size           = "Standard_B1s"
management_virtual_machine_windows_event_log_x_path_queries = [
  "Application!*[System[(Level=1 or Level=2 or Level=3)]]",
  "System!*[System[(Level=1 or Level=2 or Level=3)]]"
]

resource_prefix             = "np"
storage_account_name_prefix = "stnpdev"
vm_admin_username           = "azureadmin"
workload_name               = "network-platform"