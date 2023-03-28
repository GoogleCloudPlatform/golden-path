resource "google_project_service" "artifactregistry_googleapis_com" {
  disable_dependent_services = true
  service                    = "artifactregistry.googleapis.com"
}

resource "google_project_service" "cloudresourcemanager_googleapis_com" {
  disable_dependent_services = true
  service                    = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "cloudtrace_googleapis_com" {
  disable_dependent_services = true
  service                    = "cloudtrace.googleapis.com"
}

resource "google_project_service" "compute_googleapis_com" {
  disable_dependent_services = true
  disable_on_destroy         = false
  service                    = "compute.googleapis.com"
}

resource "google_project_service" "container_googleapis_com" {
  depends_on = [google_project_service.compute_googleapis_com]

  disable_dependent_services = true
  service                    = "container.googleapis.com"
}

resource "google_project_service" "iap_googleapis_com" {
  disable_dependent_services = true
  service                    = "iap.googleapis.com"
}

resource "google_project_service" "servicecontrol_googleapis_com" {
  disable_dependent_services = true
  service                    = "servicecontrol.googleapis.com"
}

resource "google_project_service" "servicemanagement_googleapis_com" {
  disable_dependent_services = true
  service                    = "servicemanagement.googleapis.com"
}

resource "google_project_service" "servicenetworking_googleapis_com" {
  disable_dependent_services = true
  service                    = "servicenetworking.googleapis.com"
}

resource "google_project_service" "sqladmin_googleapis_com" {
  disable_dependent_services = true
  service                    = "sqladmin.googleapis.com"
}
