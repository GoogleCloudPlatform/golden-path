variable "application_database_version" {
  default     = "14"
  description = "Version of the database to use for the application"
  type        = string
}

variable "google_billing_account_id_application" {
  default     = ""
  description = "The Google Cloud billing account ID. Required if creating a new project"
  type        = string
}

variable "google_folder_id_application" {
  default     = ""
  description = "The Google Cloud folder ID. Required if creating a new project"
  type        = string
}

variable "google_project_id_application" {
  type        = string
  description = "The Google Cloud project ID"

  validation {
    condition     = can(regex("^[a-z][-a-z0-9]{4,28}[a-z0-9]{1}$", var.google_project_id_application)) || var.google_project_id_application == ""
    error_message = "Google Cloud Project ID must be empty or 6 to 30 characters in length and can only contain lowercase letters, numbers, and hyphens"
  }
}

variable "google_region_application" {
  description = "The Google Cloud default region"
  type        = string
}

variable "google_zone_application" {
  description = "The Google Cloud default zone"
  type        = string
}
