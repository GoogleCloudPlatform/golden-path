#!/usr/bin/env bash

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

SCRIPT_PATH="$(
    cd "$(dirname "$0")" >/dev/null 2>&1
    pwd -P
)"
BASE_PATH=${SCRIPT_PATH%/*}

cd ${BASE_PATH}

rm -rf ${BASE_PATH}/terraform/000_initialize/.terraform
rm -rf ${BASE_PATH}/terraform/000_initialize/state
rm -f ${BASE_PATH}/terraform/000_initialize/.terraform.lock.hcl
rm -f ${BASE_PATH}/terraform/000_initialize/tfplan

rm -rf ${BASE_PATH}/terraform/001_application/.terraform
rm -rf ${BASE_PATH}/terraform/001_application/state
rm -f ${BASE_PATH}/terraform/001_application/.terraform.lock.hcl
rm -f ${BASE_PATH}/terraform/002_sh001_applicationared/tfplan

rm -rf ${BASE_PATH}/terraform/002_migrate/.terraform
rm -rf ${BASE_PATH}/terraform/002_migrate/state
rm -f ${BASE_PATH}/terraform/002_migrate/.terraform.lock.hcl
rm -f ${BASE_PATH}/terraform/002_migrate/tfplan

rm -rf ${BASE_PATH}/terraform/003_migrate_temp/.terraform
rm -rf ${BASE_PATH}/terraform/003_migrate_temp/state
rm -f ${BASE_PATH}/terraform/003_migrate_temp/.terraform.lock.hcl
rm -f ${BASE_PATH}/terraform/003_migrate_temp/tfplan

rm -rf ${BASE_PATH}/migrate
git restore migrate

cd ${BASE_PATH}/bank-of-anthos
git restore extras/cloudsql/kubernetes-manifests/config.yaml
git restore extras/cloudsql/kubernetes-manifests/contacts.yaml
git restore extras/cloudsql/kubernetes-manifests/frontend.yaml
git restore extras/cloudsql/kubernetes-manifests/loadgenerator.yaml
git restore extras/cloudsql/kubernetes-manifests/userservice.yaml
git restore extras/cloudsql/populate-jobs/populate-accounts-db.yaml
