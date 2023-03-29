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

resource "google_service_account" "m2c_gce_source" {
  account_id   = "m2c-gce-source"
  display_name = "Migrate to Containers GCE Source Service Account"
}

resource "google_service_account" "m2c_install" {
  account_id   = "m2c-install"
  display_name = "Migrate to Containers Install Service Account"
}
