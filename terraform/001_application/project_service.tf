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
