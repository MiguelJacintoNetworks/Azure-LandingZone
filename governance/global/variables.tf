variable "allowed_locations" {
  description = "LIST OF ALLOWED AZURE REGIONS FOR RESOURCE DEPLOYMENTS."
  type        = list(string)

  validation {
    condition     = length(var.allowed_locations) > 0 && alltrue([for location in var.allowed_locations : length(trimspace(location)) > 0])
    error_message = "AT LEAST ONE NON-EMPTY ALLOWED LOCATION MUST BE PROVIDED."
  }
}

variable "allowed_locations_effect" {
  description = "EFFECT APPLIED WHEN A RESOURCE IS DEPLOYED OUTSIDE ALLOWED LOCATIONS."
  type        = string
  default     = "Deny"

  validation {
    condition     = contains(["Audit", "Deny", "Disabled"], var.allowed_locations_effect)
    error_message = "ALLOWED VALUES ARE AUDIT, DENY, OR DISABLED."
  }
}

variable "default_tags" {
  description = "DEFAULT TAGS APPLIED TO GOVERNANCE OBJECTS."
  type        = map(string)
  default     = {}
}

variable "defender_alert_notifications" {
  description = "ENABLES ALERT NOTIFICATIONS TO THE DEFENDER FOR CLOUD SECURITY CONTACT."
  type        = bool
  default     = true
}

variable "defender_alerts_to_admins" {
  description = "ENABLES ALERT NOTIFICATIONS TO SUBSCRIPTION ADMINS."
  type        = bool
  default     = true
}

variable "defender_for_servers_subplan" {
  description = "SUBPLAN USED FOR DEFENDER FOR SERVERS."
  type        = string
  default     = "P2"

  validation {
    condition     = contains(["P1", "P2"], var.defender_for_servers_subplan)
    error_message = "ALLOWED VALUES ARE P1 OR P2."
  }
}

variable "defender_security_contact_email" {
  description = "EMAIL ADDRESS USED FOR THE DEFENDER FOR CLOUD SECURITY CONTACT."
  type        = string
  default     = ""

  validation {
    condition     = trimspace(var.defender_security_contact_email) == "" || can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", trimspace(var.defender_security_contact_email)))
    error_message = "THE DEFENDER SECURITY CONTACT EMAIL MUST BE EMPTY OR A VALID EMAIL ADDRESS."
  }
}

variable "defender_security_contact_phone" {
  description = "PHONE NUMBER USED FOR THE DEFENDER FOR CLOUD SECURITY CONTACT."
  type        = string
  default     = ""

  validation {
    condition     = trimspace(var.defender_security_contact_phone) == "" || can(regex("^[0-9+()\\-\\s]+$", trimspace(var.defender_security_contact_phone)))
    error_message = "THE DEFENDER SECURITY CONTACT PHONE MUST BE EMPTY OR CONTAIN ONLY VALID PHONE CHARACTERS."
  }
}

variable "enable_defender_for_cloud" {
  description = "ENABLES THE DEFENDER FOR CLOUD BASELINE."
  type        = bool
  default     = true
}

variable "enable_defender_for_servers" {
  description = "ENABLES THE DEFENDER FOR SERVERS PLAN."
  type        = bool
  default     = true
}

variable "enable_entra_groups" {
  description = "ENABLES CREATION OF MICROSOFT ENTRA SECURITY GROUPS FOR THE IDENTITY BASELINE."
  type        = bool
  default     = true
}

variable "environment" {
  description = "DEPLOYMENT ENVIRONMENT NAME."
  type        = string

  validation {
    condition     = length(trimspace(var.environment)) > 0
    error_message = "ENVIRONMENT MUST NOT BE EMPTY."
  }
}

variable "identity_members" {
  description = "OBJECT CONTAINING MEMBER OBJECT IDS FOR EACH MICROSOFT ENTRA GROUP."
  type = object({
    platform_admins   = list(string)
    platform_readers  = list(string)
    security_auditors = list(string)
  })

  default = {
    platform_admins   = []
    platform_readers  = []
    security_auditors = []
  }

  validation {
    condition = alltrue([
      for id in concat(
        var.identity_members.platform_admins,
        var.identity_members.platform_readers,
        var.identity_members.security_auditors
      ) : can(regex("^[0-9a-fA-F-]{36}$", id))
    ])
    error_message = "ALL IDENTITY MEMBER OBJECT IDS MUST BE VALID GUIDS."
  }
}

variable "location" {
  description = "PRIMARY AZURE REGION USED FOR GOVERNANCE CONFIGURATION."
  type        = string

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "LOCATION MUST NOT BE EMPTY."
  }
}

variable "platform_admin_role_definition_name" {
  description = "BUILT-IN ROLE NAME ASSIGNED TO THE PLATFORM ADMINS GROUP."
  type        = string
  default     = "Contributor"

  validation {
    condition     = length(trimspace(var.platform_admin_role_definition_name)) > 0
    error_message = "PLATFORM ADMIN ROLE DEFINITION NAME MUST NOT BE EMPTY."
  }
}

variable "platform_reader_role_definition_name" {
  description = "BUILT-IN ROLE NAME ASSIGNED TO THE PLATFORM READERS GROUP."
  type        = string
  default     = "Reader"

  validation {
    condition     = length(trimspace(var.platform_reader_role_definition_name)) > 0
    error_message = "PLATFORM READER ROLE DEFINITION NAME MUST NOT BE EMPTY."
  }
}

variable "public_network_access_effect" {
  description = "EFFECT APPLIED WHEN PUBLIC NETWORK ACCESS IS ENABLED ON RESTRICTED RESOURCES."
  type        = string
  default     = "Audit"

  validation {
    condition     = contains(["Audit", "Deny", "Disabled"], var.public_network_access_effect)
    error_message = "ALLOWED VALUES ARE AUDIT, DENY, OR DISABLED."
  }
}

variable "required_tag_names" {
  description = "LIST OF REQUIRED TAG NAMES."
  type        = list(string)

  validation {
    condition     = length(var.required_tag_names) > 0 && alltrue([for tag_name in var.required_tag_names : length(trimspace(tag_name)) > 0])
    error_message = "AT LEAST ONE NON-EMPTY REQUIRED TAG NAME MUST BE PROVIDED."
  }
}

variable "resource_prefix" {
  description = "SHORT PREFIX USED TO BUILD RESOURCE NAMES."
  type        = string

  validation {
    condition     = length(trimspace(var.resource_prefix)) > 0
    error_message = "RESOURCE PREFIX MUST NOT BE EMPTY."
  }
}

variable "security_auditor_role_definition_name" {
  description = "BUILT-IN ROLE NAME ASSIGNED TO THE SECURITY AUDITORS GROUP."
  type        = string
  default     = "Reader"

  validation {
    condition     = length(trimspace(var.security_auditor_role_definition_name)) > 0
    error_message = "SECURITY AUDITOR ROLE DEFINITION NAME MUST NOT BE EMPTY."
  }
}

variable "tag_compliance_effect" {
  description = "EFFECT APPLIED WHEN REQUIRED TAGS ARE MISSING."
  type        = string
  default     = "Audit"

  validation {
    condition     = contains(["Audit", "Deny", "Disabled"], var.tag_compliance_effect)
    error_message = "ALLOWED VALUES ARE AUDIT, DENY, OR DISABLED."
  }
}

variable "target_subscription_id" {
  description = "TARGET SUBSCRIPTION ID USED FOR GOVERNANCE DEPLOYMENT. IF NULL, THE CURRENT SUBSCRIPTION IS USED."
  type        = string
  default     = null

  validation {
    condition     = var.target_subscription_id == null || can(regex("^[0-9a-fA-F-]{36}$", var.target_subscription_id))
    error_message = "TARGET SUBSCRIPTION ID MUST BE NULL OR A VALID GUID."
  }
}

variable "workload_name" {
  description = "WORKLOAD NAME USED FOR TAGGING AND NAMING COMPOSITION."
  type        = string

  validation {
    condition     = length(trimspace(var.workload_name)) > 0
    error_message = "WORKLOAD NAME MUST NOT BE EMPTY."
  }
}