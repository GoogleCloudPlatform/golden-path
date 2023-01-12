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
