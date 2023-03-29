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
