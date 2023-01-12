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
