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

resource "google_service_account" "wi_application_backend" {
  account_id   = "wi-application-backend"
  display_name = "Application Backend Service Account"
}

resource "google_service_account" "wi_application_default" {
  account_id   = "wi-application-default"
  display_name = "Application Default Service Account"
}

resource "google_service_account" "vm_database" {
  account_id   = "vm-database"
  display_name = "Database Service Account"
}

resource "google_service_account" "vm_gke" {
  account_id   = "vm-gke"
  display_name = "GKE Service Account"
}

resource "google_service_account" "vm_service" {
  account_id   = "vm-service"
  display_name = "Service Service Account"
}

resource "google_service_account_iam_binding" "wi_application_backend_iam_wi_user" {
  depends_on = [google_container_cluster.application]

  service_account_id = google_service_account.wi_application_backend.name
  role               = "roles/iam.workloadIdentityUser"

  members = ["serviceAccount:${data.google_project.application.project_id}.svc.id.goog[${local.k8s_app_namespace}/backend]"]
}

resource "google_service_account_iam_binding" "wi_application_default_iam_wi_user" {
  depends_on = [google_container_cluster.application]

  service_account_id = google_service_account.wi_application_default.name
  role               = "roles/iam.workloadIdentityUser"

  members = ["serviceAccount:${data.google_project.application.project_id}.svc.id.goog[${local.k8s_app_namespace}/default]"]
}
