variable "project_name" {
  description = "PROJECT NAME USED FOR NAMING."
  type        = string
  default     = "network-platform"
}

variable "github_repository" {
  description = "GITHUB REPOSITORY IN THE FORMAT OWNER/REPO"
  type        = string

  validation {
    condition     = can(regex("^[^/]+/[^/]+$", var.github_repository))
    error_message = "THE GITHUB REPOSITORY MUST BE IN THE FORMAT OWNER/REPO."
  }
}

variable "github_branch" {
  description = "GITHUB BRANCH USED FOR OIDC."
  type        = string
  default     = "main"
}