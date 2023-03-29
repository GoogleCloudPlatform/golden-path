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

resource "google_sql_database_instance" "application" {
  depends_on = [google_project_service.sqladmin_googleapis_com]

  database_version    = "POSTGRES_${var.application_database_version}"
  deletion_protection = false
  name                = "application-db"
  region              = var.google_region_application

  settings {
    availability_type = "ZONAL"
    tier              = "db-custom-1-4096"
  }
}

resource "google_sql_database" "accounts" {
  name     = "accounts-db"
  instance = google_sql_database_instance.application.name
}

resource "random_password" "admin_db_password" {
  length           = 16
  special          = true
  override_special = "!%*()-_{}<>"
}

resource "google_sql_user" "admin_db_user" {
  name     = "admin"
  instance = google_sql_database_instance.application.name
  password = random_password.admin_db_password.result
}
