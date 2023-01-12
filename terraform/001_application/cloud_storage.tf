resource "google_storage_bucket" "project" {
  force_destroy               = true
  location                    = var.google_region_application
  name                        = data.google_project.application.project_id
  project                     = data.google_project.application.project_id
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_member" "database_storage_objectViewer" {
  bucket = google_storage_bucket.project.name
  member = google_service_account.vm_database.member
  role   = "roles/storage.objectViewer"
}

resource "google_storage_bucket_iam_member" "service_storage_objectViewer" {
  bucket = google_storage_bucket.project.name
  member = google_service_account.vm_service.member
  role   = "roles/storage.objectViewer"
}
