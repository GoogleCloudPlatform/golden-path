resource "google_project_service" "datamigration_googleapis_com" {
  disable_dependent_services = true
  service                    = "datamigration.googleapis.com"
}
