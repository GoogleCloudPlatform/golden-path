resource "google_project_service" "datamigration_googleapis_com" {
  disable_dependent_services = true
  service                    = "datamigration.googleapis.com"
}

resource "google_project_service" "servicenetworking_googleapis_com" {
  disable_dependent_services = true
  service                    = "servicenetworking.googleapis.com"
}
