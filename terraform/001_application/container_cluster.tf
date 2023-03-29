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

resource "google_container_cluster" "application" {
  depends_on = [google_project_service.container_googleapis_com]

  enable_autopilot = true
  location         = var.google_region_application
  name             = "application-cluster"

  cluster_autoscaling {
    auto_provisioning_defaults {
      service_account = google_service_account.vm_gke.email
    }
  }
  ip_allocation_policy {
  }
  private_cluster_config {
    enable_private_nodes = true
  }
  release_channel {
    channel = "REGULAR"
  }
}
