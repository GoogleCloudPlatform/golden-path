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
