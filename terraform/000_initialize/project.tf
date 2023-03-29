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

locals {
  generated_project_id = "app-${random_string.unique_identifier.result}"
}

resource "random_string" "unique_identifier" {
  length  = 26
  special = false
  upper   = false
}

resource "google_project" "application" {
  billing_account = var.google_billing_account_id_application
  folder_id       = var.google_folder_id_application
  name            = "application"
  project_id      = local.generated_project_id
}
