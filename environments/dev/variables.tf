variable "alert_email_address" {
  description = "EMAIL ADDRESS USED BY THE MONITOR ACTION GROUP."
  type        = string

  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.alert_email_address))
    error_message = "THE ALERT EMAIL ADDRESS MUST BE VALID."
  }
}

variable "alert_email_receiver_name" {
  description = "NAME OF THE EMAIL RECEIVER USED BY THE MONITOR ACTION GROUP."
  type        = string
  default     = "PRIMARYEMAIL"

  validation {
    condition     = length(var.alert_email_receiver_name) > 0
    error_message = "THE ALERT EMAIL RECEIVER NAME MUST NOT BE EMPTY."
  }
}

variable "backup_immutability_state" {
  description = "IMMUTABILITY STATE FOR THE RECOVERY SERVICES VAULT."
  type        = string
  default     = "Disabled"

  validation {
    condition = contains([
      "Disabled",
      "Locked",
      "Unlocked"
    ], var.backup_immutability_state)
    error_message = "INVALID BACKUP IMMUTABILITY STATE."
  }
}

variable "backup_policy_backup_frequency" {
  description = "BACKUP FREQUENCY FOR THE VIRTUAL MACHINE BACKUP POLICY."
  type        = string
  default     = "Daily"

  validation {
    condition = contains([
      "Daily",
      "Weekly"
    ], var.backup_policy_backup_frequency)
    error_message = "INVALID BACKUP POLICY FREQUENCY."
  }
}

variable "backup_policy_backup_time" {
  description = "BACKUP TIME FOR THE VIRTUAL MACHINE BACKUP POLICY."
  type        = string
  default     = "23:00"

  validation {
    condition     = can(regex("^([01][0-9]|2[0-3]):[0-5][0-9]$", var.backup_policy_backup_time))
    error_message = "THE BACKUP POLICY TIME MUST BE IN HH:MM FORMAT."
  }
}

variable "backup_policy_retention_daily_count" {
  description = "DAILY RETENTION COUNT FOR THE VIRTUAL MACHINE BACKUP POLICY."
  type        = number
  default     = 7

  validation {
    condition     = var.backup_policy_retention_daily_count >= 1
    error_message = "THE BACKUP POLICY RETENTION DAILY COUNT MUST BE GREATER THAN OR EQUAL TO 1."
  }
}

variable "backup_public_network_access" {
  description = "PUBLIC NETWORK ACCESS SETTING FOR THE RECOVERY SERVICES VAULT."
  type        = string
  default     = "Enabled"

  validation {
    condition = contains([
      "Disabled",
      "Enabled"
    ], var.backup_public_network_access)
    error_message = "INVALID BACKUP PUBLIC NETWORK ACCESS VALUE."
  }
}

variable "backup_soft_delete_retention_period_in_days" {
  description = "SOFT DELETE RETENTION PERIOD IN DAYS FOR THE RECOVERY SERVICES VAULT."
  type        = number
  default     = 14

  validation {
    condition     = var.backup_soft_delete_retention_period_in_days >= 1
    error_message = "THE BACKUP SOFT DELETE RETENTION PERIOD MUST BE GREATER THAN OR EQUAL TO 1."
  }
}

variable "backup_soft_delete_state" {
  description = "SOFT DELETE STATE FOR THE RECOVERY SERVICES VAULT."
  type        = string
  default     = "Enabled"

  validation {
    condition = contains([
      "AlwaysON",
      "Disabled",
      "Enabled"
    ], var.backup_soft_delete_state)
    error_message = "INVALID BACKUP SOFT DELETE STATE."
  }
}

variable "default_tags" {
  description = "DEFAULT TAGS APPLIED TO ALL RESOURCES."
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "DEPLOYMENT ENVIRONMENT NAME."
  type        = string

  validation {
    condition     = length(var.environment) > 0
    error_message = "THE ENVIRONMENT MUST NOT BE EMPTY."
  }
}

variable "firewall_policy_sku" {
  description = "SKU USED FOR THE FIREWALL POLICY."
  type        = string
  default     = "Standard"

  validation {
    condition = contains([
      "Basic",
      "Premium",
      "Standard"
    ], var.firewall_policy_sku)
    error_message = "INVALID FIREWALL POLICY SKU."
  }
}

variable "firewall_policy_threat_intelligence_mode" {
  description = "THREAT INTELLIGENCE MODE USED FOR THE FIREWALL POLICY."
  type        = string
  default     = "Alert"

  validation {
    condition = contains([
      "Alert",
      "Deny",
      "Off"
    ], var.firewall_policy_threat_intelligence_mode)
    error_message = "INVALID FIREWALL POLICY THREAT INTELLIGENCE MODE."
  }
}

variable "firewall_sku_name" {
  description = "SKU NAME USED FOR THE FIREWALL."
  type        = string
  default     = "AZFW_VNet"

  validation {
    condition = contains([
      "AZFW_Hub",
      "AZFW_VNet"
    ], var.firewall_sku_name)
    error_message = "INVALID FIREWALL SKU NAME."
  }
}

variable "firewall_sku_tier" {
  description = "SKU TIER USED FOR THE FIREWALL."
  type        = string
  default     = "Standard"

  validation {
    condition = contains([
      "Basic",
      "Premium",
      "Standard"
    ], var.firewall_sku_tier)
    error_message = "INVALID FIREWALL SKU TIER."
  }
}

variable "location" {
  description = "AZURE REGION USED FOR RESOURCE DEPLOYMENT."
  type        = string

  validation {
    condition     = length(var.location) > 0
    error_message = "THE LOCATION MUST NOT BE EMPTY."
  }
}

variable "log_analytics_retention_in_days" {
  description = "RETENTION PERIOD IN DAYS FOR THE LOG ANALYTICS WORKSPACE."
  type        = number
  default     = 30

  validation {
    condition     = var.log_analytics_retention_in_days >= 7
    error_message = "THE LOG ANALYTICS RETENTION PERIOD MUST BE GREATER THAN OR EQUAL TO 7."
  }
}

variable "log_analytics_sku" {
  description = "SKU USED FOR THE LOG ANALYTICS WORKSPACE."
  type        = string
  default     = "PerGB2018"
}

variable "maintenance_configuration_duration" {
  description = "DURATION OF THE MAINTENANCE WINDOW."
  type        = string
  default     = "03:00"
}

variable "maintenance_configuration_reboot_setting" {
  description = "REBOOT SETTING USED BY THE MAINTENANCE CONFIGURATION."
  type        = string
  default     = "IfRequired"

  validation {
    condition = contains([
      "Always",
      "IfRequired",
      "Never"
    ], var.maintenance_configuration_reboot_setting)
    error_message = "INVALID MAINTENANCE CONFIGURATION REBOOT SETTING."
  }
}

variable "maintenance_configuration_recur_every" {
  description = "RECURRENCE EXPRESSION OF THE MAINTENANCE WINDOW."
  type        = string
  default     = "Week Saturday"
}

variable "maintenance_configuration_start_date_time" {
  description = "START DATE AND TIME OF THE MAINTENANCE WINDOW."
  type        = string
  default     = "2024-01-01 02:00"
}

variable "maintenance_configuration_time_zone" {
  description = "TIME ZONE OF THE MAINTENANCE WINDOW."
  type        = string
  default     = "UTC"
}

variable "maintenance_configuration_windows_classifications" {
  description = "WINDOWS UPDATE CLASSIFICATIONS INCLUDED IN THE MAINTENANCE CONFIGURATION."
  type        = list(string)
  default     = ["Critical", "Security"]
}

variable "management_allowed_destination_fqdns" {
  description = "LIST OF OUTBOUND FQDNS ALLOWED FOR THE MANAGEMENT NETWORK THROUGH THE FIREWALL POLICY."
  type        = list(string)
  default = [
    "www.google.com",
    "www.esamarante.edu.pt"
  ]
}

variable "management_virtual_machine_bypass_platform_safety_checks_on_user_schedule_enabled" {
  description = "WHETHER PLATFORM SAFETY CHECKS ARE BYPASSED FOR THE MANAGEMENT VIRTUAL MACHINE PATCHING CONFIGURATION."
  type        = bool
  default     = true
}

variable "management_virtual_machine_cpu_alert_evaluation_frequency" {
  description = "EVALUATION FREQUENCY OF THE CPU METRIC ALERT FOR THE MANAGEMENT VIRTUAL MACHINE."
  type        = string
  default     = "PT1M"
}

variable "management_virtual_machine_cpu_alert_severity" {
  description = "SEVERITY OF THE CPU METRIC ALERT FOR THE MANAGEMENT VIRTUAL MACHINE."
  type        = number
  default     = 2

  validation {
    condition     = var.management_virtual_machine_cpu_alert_severity >= 0 && var.management_virtual_machine_cpu_alert_severity <= 4
    error_message = "THE MANAGEMENT VIRTUAL MACHINE CPU ALERT SEVERITY MUST BE BETWEEN 0 AND 4."
  }
}

variable "management_virtual_machine_cpu_alert_threshold" {
  description = "THRESHOLD OF THE CPU METRIC ALERT FOR THE MANAGEMENT VIRTUAL MACHINE."
  type        = number
  default     = 80
}

variable "management_virtual_machine_cpu_alert_window_size" {
  description = "WINDOW SIZE OF THE CPU METRIC ALERT FOR THE MANAGEMENT VIRTUAL MACHINE."
  type        = string
  default     = "PT5M"
}

variable "management_virtual_machine_heartbeat_alert_evaluation_frequency" {
  description = "EVALUATION FREQUENCY OF THE HEARTBEAT ALERT FOR THE MANAGEMENT VIRTUAL MACHINE."
  type        = string
  default     = "PT5M"
}

variable "management_virtual_machine_heartbeat_alert_severity" {
  description = "SEVERITY OF THE HEARTBEAT ALERT FOR THE MANAGEMENT VIRTUAL MACHINE."
  type        = number
  default     = 1

  validation {
    condition     = var.management_virtual_machine_heartbeat_alert_severity >= 0 && var.management_virtual_machine_heartbeat_alert_severity <= 4
    error_message = "THE MANAGEMENT VIRTUAL MACHINE HEARTBEAT ALERT SEVERITY MUST BE BETWEEN 0 AND 4."
  }
}

variable "management_virtual_machine_heartbeat_alert_threshold" {
  description = "THRESHOLD OF THE HEARTBEAT ALERT FOR THE MANAGEMENT VIRTUAL MACHINE."
  type        = number
  default     = 1
}

variable "management_virtual_machine_heartbeat_alert_window_duration" {
  description = "WINDOW DURATION OF THE HEARTBEAT ALERT FOR THE MANAGEMENT VIRTUAL MACHINE."
  type        = string
  default     = "PT10M"
}

variable "management_virtual_machine_patch_mode" {
  description = "PATCH MODE USED FOR THE MANAGEMENT VIRTUAL MACHINE."
  type        = string
  default     = "AutomaticByPlatform"

  validation {
    condition = contains([
      "AutomaticByOS",
      "AutomaticByPlatform",
      "Manual"
    ], var.management_virtual_machine_patch_mode)
    error_message = "INVALID MANAGEMENT VIRTUAL MACHINE PATCH MODE."
  }
}

variable "management_virtual_machine_performance_counter_sampling_frequency_in_seconds" {
  description = "SAMPLING FREQUENCY IN SECONDS FOR MANAGEMENT VIRTUAL MACHINE PERFORMANCE COUNTERS."
  type        = number
  default     = 60
}

variable "management_virtual_machine_performance_counter_specifiers" {
  description = "PERFORMANCE COUNTERS COLLECTED FROM THE MANAGEMENT VIRTUAL MACHINE."
  type        = list(string)
  default = [
    "\\Processor(_Total)\\% Processor Time",
    "\\Memory\\Available MBytes",
    "\\LogicalDisk(_Total)\\% Free Space"
  ]
}

variable "management_virtual_machine_reboot_setting" {
  description = "REBOOT SETTING USED FOR THE MANAGEMENT VIRTUAL MACHINE PATCHING CONFIGURATION."
  type        = string
  default     = "IfRequired"

  validation {
    condition = contains([
      "Always",
      "IfRequired",
      "Never"
    ], var.management_virtual_machine_reboot_setting)
    error_message = "INVALID MANAGEMENT VIRTUAL MACHINE REBOOT SETTING."
  }
}

variable "management_virtual_machine_size" {
  description = "SIZE OF THE MANAGEMENT VIRTUAL MACHINE."
  type        = string

  validation {
    condition     = length(var.management_virtual_machine_size) > 0
    error_message = "THE MANAGEMENT VIRTUAL MACHINE SIZE MUST NOT BE EMPTY."
  }
}

variable "management_virtual_machine_windows_event_log_x_path_queries" {
  description = "WINDOWS EVENT LOG XPATH QUERIES COLLECTED FROM THE MANAGEMENT VIRTUAL MACHINE."
  type        = list(string)
  default = [
    "Application!*[System[(Level=1 or Level=2 or Level=3)]]",
    "System!*[System[(Level=1 or Level=2 or Level=3)]]"
  ]
}

variable "resource_prefix" {
  description = "SHORT PREFIX USED TO BUILD RESOURCE NAMES."
  type        = string

  validation {
    condition     = length(var.resource_prefix) > 0
    error_message = "THE RESOURCE PREFIX MUST NOT BE EMPTY."
  }
}

variable "storage_account_name_prefix" {
  description = "SHORT PREFIX USED TO BUILD THE STORAGE ACCOUNT NAME."
  type        = string

  validation {
    condition     = length(var.storage_account_name_prefix) > 0
    error_message = "THE STORAGE ACCOUNT NAME PREFIX MUST NOT BE EMPTY."
  }
}

variable "vm_admin_password" {
  description = "ADMIN PASSWORD FOR THE MANAGEMENT VIRTUAL MACHINE."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.vm_admin_password) >= 12
    error_message = "THE VM ADMIN PASSWORD MUST BE AT LEAST 12 CHARACTERS LONG."
  }
}

variable "vm_admin_username" {
  description = "ADMIN USERNAME FOR THE MANAGEMENT VIRTUAL MACHINE."
  type        = string

  validation {
    condition     = length(var.vm_admin_username) > 0
    error_message = "THE VM ADMIN USERNAME MUST NOT BE EMPTY."
  }
}

variable "workload_name" {
  description = "WORKLOAD NAME USED FOR TAGGING AND NAMING COMPOSITION."
  type        = string

  validation {
    condition     = length(var.workload_name) > 0
    error_message = "THE WORKLOAD NAME MUST NOT BE EMPTY."
  }
}

variable "platform_sentinel_version" {
  description = "VERSION IDENTIFIER OF THE PLATFORM SENTINEL ARTIFACT."
  type        = string

  validation {
    condition     = length(trimspace(var.platform_sentinel_version)) > 0
    error_message = "THE PLATFORM SENTINEL VERSION MUST NOT BE EMPTY."
  }
}

variable "platform_sentinel_artifact_storage_account_name" {
  description = "NAME OF THE STORAGE ACCOUNT THAT HOSTS THE PLATFORM SENTINEL ARTIFACTS."
  type        = string

  validation {
    condition     = length(trimspace(var.platform_sentinel_artifact_storage_account_name)) > 0
    error_message = "THE PLATFORM SENTINEL ARTIFACT STORAGE ACCOUNT NAME MUST NOT BE EMPTY."
  }
}

variable "platform_sentinel_artifact_storage_account_id" {
  description = "RESOURCE ID OF THE STORAGE ACCOUNT THAT HOSTS THE PLATFORM SENTINEL ARTIFACTS."
  type        = string

  validation {
    condition     = length(trimspace(var.platform_sentinel_artifact_storage_account_id)) > 0
    error_message = "THE PLATFORM SENTINEL ARTIFACT STORAGE ACCOUNT ID MUST NOT BE EMPTY."
  }
}

variable "platform_sentinel_artifact_container_name" {
  description = "NAME OF THE STORAGE CONTAINER THAT HOSTS THE PLATFORM SENTINEL ARTIFACTS."
  type        = string

  validation {
    condition     = length(trimspace(var.platform_sentinel_artifact_container_name)) > 0
    error_message = "THE PLATFORM SENTINEL ARTIFACT CONTAINER NAME MUST NOT BE EMPTY."
  }
}

variable "platform_sentinel_package_blob_name" {
  description = "BLOB NAME OF THE PLATFORM SENTINEL PACKAGE ZIP."
  type        = string

  validation {
    condition     = length(trimspace(var.platform_sentinel_package_blob_name)) > 0
    error_message = "THE PLATFORM SENTINEL PACKAGE BLOB NAME MUST NOT BE EMPTY."
  }
}

variable "platform_sentinel_install_script_blob_name" {
  description = "BLOB NAME OF THE PLATFORM SENTINEL INSTALL SCRIPT."
  type        = string

  validation {
    condition     = length(trimspace(var.platform_sentinel_install_script_blob_name)) > 0
    error_message = "THE PLATFORM SENTINEL INSTALL SCRIPT BLOB NAME MUST NOT BE EMPTY."
  }
}

variable "enable_platform_sentinel_extension" {
  description = "WHETHER THE PLATFORM SENTINEL CUSTOM SCRIPT EXTENSION SHOULD BE DEPLOYED."
  type        = bool
  default     = true
}

variable "platform_sentinel_artifact_allowed_fqdns" {
  description = "LIST OF ADDITIONAL FQDNS REQUIRED FOR PLATFORM SENTINEL ARTIFACT DOWNLOADS."
  type        = list(string)
  default     = []
}