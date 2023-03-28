resource "google_project_iam_member" "wi_application_backend_cloudtrace_agent" {
  member  = google_service_account.wi_application_backend.member
  project = data.google_project.application.project_id
  role    = "roles/cloudtrace.agent"
}

resource "google_project_iam_member" "wi_application_backend_cloudsql_client" {
  depends_on = [google_project_service.sqladmin_googleapis_com]

  member  = google_service_account.wi_application_backend.member
  project = data.google_project.application.project_id
  role    = "roles/cloudsql.client"
}

resource "google_project_iam_member" "wi_application_backend_logging_logwriter" {
  member  = google_service_account.wi_application_backend.member
  project = data.google_project.application.project_id
  role    = "roles/logging.logWriter"
}

resource "google_project_iam_member" "wi_application_backend_monitoring_metricwriter" {
  member  = google_service_account.wi_application_backend.member
  project = data.google_project.application.project_id
  role    = "roles/monitoring.metricWriter"
}

resource "google_project_iam_member" "wi_application_backend_storage_objectviewer" {
  member  = google_service_account.wi_application_backend.member
  project = data.google_project.application.project_id
  role    = "roles/storage.objectViewer"
}

resource "google_project_iam_member" "wi_application_default_cloudtrace_agent" {
  member  = google_service_account.wi_application_default.member
  project = data.google_project.application.project_id
  role    = "roles/cloudtrace.agent"
}

resource "google_project_iam_member" "wi_application_default_logging_logwriter" {
  member  = google_service_account.wi_application_default.member
  project = data.google_project.application.project_id
  role    = "roles/logging.logWriter"
}

resource "google_project_iam_member" "wi_application_default_monitoring_metricwriter" {
  member  = google_service_account.wi_application_default.member
  project = data.google_project.application.project_id
  role    = "roles/monitoring.metricWriter"
}

resource "google_project_iam_member" "wi_application_default_storage_objectviewer" {
  member  = google_service_account.wi_application_default.member
  project = data.google_project.application.project_id
  role    = "roles/storage.objectViewer"
}

resource "google_project_iam_member" "vm_database_logging_logwriter" {
  member  = google_service_account.vm_database.member
  project = data.google_project.application.project_id
  role    = "roles/logging.logWriter"
}

resource "google_project_iam_member" "vm_gke_container_nodeserviceaccount" {
  member  = google_service_account.vm_gke.member
  project = data.google_project.application.project_id
  role    = "roles/container.nodeServiceAccount"
}

resource "google_project_iam_member" "vm_service_cloudsql_client" {
  depends_on = [google_project_service.sqladmin_googleapis_com]

  member  = google_service_account.vm_service.member
  project = data.google_project.application.project_id
  role    = "roles/cloudsql.client"
}

resource "google_project_iam_member" "vm_service_logging_logwriter" {
  member  = google_service_account.vm_service.member
  project = data.google_project.application.project_id
  role    = "roles/logging.logWriter"
}

resource "google_project_iam_member" "vm_service_monitoring_metricwriter" {
  member  = google_service_account.vm_service.member
  project = data.google_project.application.project_id
  role    = "roles/monitoring.metricWriter"
}
