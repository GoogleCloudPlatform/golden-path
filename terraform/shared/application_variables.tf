# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
