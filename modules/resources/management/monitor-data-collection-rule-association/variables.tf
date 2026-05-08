variable "name" {
  description = "NAME OF THE DATA COLLECTION RULE ASSOCIATION."
  type        = string

  validation {
    condition     = length(var.name) >= 1
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "target_resource_id" {
  description = "RESOURCE ID OF THE TARGET RESOURCE TO ASSOCIATE WITH THE DATA COLLECTION RULE."
  type        = string

  validation {
    condition     = length(var.target_resource_id) > 0
    error_message = "THE TARGET RESOURCE ID MUST NOT BE EMPTY."
  }
}

variable "data_collection_rule_id" {
  description = "RESOURCE ID OF THE DATA COLLECTION RULE."
  type        = string

  validation {
    condition     = length(var.data_collection_rule_id) > 0
    error_message = "THE DATA COLLECTION RULE ID MUST NOT BE EMPTY."
  }
}

variable "description" {
  description = "DESCRIPTION OF THE DATA COLLECTION RULE ASSOCIATION."
  type        = string
  default     = null
}