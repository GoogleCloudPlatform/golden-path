resource "google_project_iam_member" "m2c_gce_source_compute_storageadmin" {
  member  = google_service_account.m2c_gce_source.member
  project = data.google_project.application.project_id
  role    = "roles/compute.storageAdmin"
}

resource "google_project_iam_member" "m2c_gce_source_compute_viewer" {
  member  = google_service_account.m2c_gce_source.member
  project = data.google_project.application.project_id
  role    = "roles/compute.viewer"
}

resource "google_project_iam_member" "m2c_install_storage_admin" {
  member  = google_service_account.m2c_install.member
  project = data.google_project.application.project_id
  role    = "roles/storage.admin"
}
