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

resource "local_file" "auto_tfvars" {
  content = templatefile("../${path.module}/000_initialize/templates/auto.tfvars.tftpl",
    {
      billing_account  = var.google_billing_account_id_application,
      database_version = var.application_database_version
      folder_id        = var.google_folder_id_application,
      project_id       = local.generated_project_id,
      region           = var.google_region_application
      zone             = var.google_zone_application
    }
  )
  filename = "../${path.module}/shared/application.auto.tfvars"
}
