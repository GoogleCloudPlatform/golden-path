locals {
  service_internal_fqdn          = "${google_compute_instance.service.name}.${google_compute_instance.service.zone}.c.${data.google_project.application.project_id}.internal:8080"
  application_config_file        = "extras/cloudsql/kubernetes-manifests/config.yaml"
  application_contacts_yaml      = "extras/cloudsql/kubernetes-manifests/contacts.yaml"
  application_jwt_secret_file    = "extras/cloudsql/kubernetes-manifests/jwt-secret.yaml"
  application_frontend_yaml      = "extras/cloudsql/kubernetes-manifests/frontend.yaml"
  application_loadgenerator_yaml = "extras/cloudsql/kubernetes-manifests/loadgenerator.yaml"
  application_userservice_yaml   = "extras/cloudsql/kubernetes-manifests/userservice.yaml"
  populate_job_account_db_yaml   = "extras/cloudsql/populate-jobs/populate-accounts-db.yaml"

  database_connection_name = google_sql_database_instance.application.connection_name
  database_admin_user_name = google_sql_user.admin_db_user.name
  database_admin_password  = nonsensitive(random_password.admin_db_password.result)

  database_account_db_name = google_sql_database.accounts.name
  database_account_db_url  = "postgresql://${local.database_admin_user_name}:${local.database_admin_password}@127.0.0.1:5432/${local.database_account_db_name}"

  database_ledger_db_name = "ledger-db"
  database_ledger_db_url  = "jdbc:postgresql://127.0.0.1:5432/${local.database_ledger_db_name}"

  k8s_app_namespace          = "application"
  k8s_frontend_service_patch = templatefile("${path.module}/templates/frontend-service-patch.tftpl", { application_static_address = google_compute_address.application.address })
  k8s_sa_backend             = "backend"
  k8s_sa_default             = "default"
}

resource "null_resource" "prepare_manifests" {
  provisioner "local-exec" {
    command     = <<EOT
echo "Restore files" && \
git restore ${local.application_config_file} ${local.application_contacts_yaml} ${local.application_frontend_yaml} ${local.application_loadgenerator_yaml} ${local.application_userservice_yaml} ${local.populate_job_account_db_yaml} && \
echo "Configure the API endpoints" && \
sed -i 's/^\([[:blank:]]*\)TRANSACTIONS_API_ADDR: .*$/\1TRANSACTIONS_API_ADDR: ${local.service_internal_fqdn}/' ${local.application_config_file} && \
sed -i 's/^\([[:blank:]]*\)BALANCES_API_ADDR: .*$/\1BALANCES_API_ADDR: ${local.service_internal_fqdn}/' ${local.application_config_file} && \
sed -i 's/^\([[:blank:]]*\)HISTORY_API_ADDR: .*$/\1HISTORY_API_ADDR: ${local.service_internal_fqdn}/' ${local.application_config_file} && \
echo "Configure database" && \
sed -i 's|^\([[:blank:]]*\)ACCOUNTS_DB_URI: .*$|\1ACCOUNTS_DB_URI: ${local.database_account_db_url}|' ${local.application_config_file} && \
sed -i 's|^\([[:blank:]]*\)POSTGRES_DB: .*$|\1POSTGRES_DB: ${local.database_ledger_db_name}|' ${local.application_config_file} && \
sed -i 's|^\([[:blank:]]*\)POSTGRES_USER: .*$|\1POSTGRES_USER: ${local.database_admin_user_name}|' ${local.application_config_file} && \
sed -i 's|^\([[:blank:]]*\)POSTGRES_PASSWORD: .*$|\1POSTGRES_PASSWORD: "${local.database_admin_password}"|' ${local.application_config_file} && \
sed -i 's|^\([[:blank:]]*\)SPRING_DATASOURCE_USERNAME: .*$|\1SPRING_DATASOURCE_USERNAME: ${local.database_admin_user_name}|' ${local.application_config_file} && \
sed -i 's|^\([[:blank:]]*\)SPRING_DATASOURCE_PASSWORD: .*$|\1SPRING_DATASOURCE_PASSWORD: "${local.database_admin_password}"|' ${local.application_config_file} && \
echo "Enable Cymbal Bank branding" && \
sed -i ':a;N;$!ba;s/# - name: CYMBAL_LOGO\n        #   value: "false"/- name: CYMBAL_LOGO\n          value: "true"/' ${local.application_frontend_yaml} && \
echo "Configure service account" && \
sed -i "s/serviceAccountName: boa-ksa/serviceAccountName: ${local.k8s_sa_backend}/" ${local.application_contacts_yaml} && \
sed -i "s/serviceAccountName: boa-ksa/serviceAccountName: ${local.k8s_sa_default}/" ${local.application_frontend_yaml} && \
sed -i "s/serviceAccountName: boa-ksa/serviceAccountName: ${local.k8s_sa_default}/" ${local.application_loadgenerator_yaml} && \
sed -i "s/serviceAccountName: boa-ksa/serviceAccountName: ${local.k8s_sa_backend}/" ${local.application_userservice_yaml} && \
sed -i "s/serviceAccountName: boa-ksa/serviceAccountName: ${local.k8s_sa_backend}/" ${local.populate_job_account_db_yaml}
    EOT
    interpreter = ["bash", "-c"]
    working_dir = "${path.module}/../../cymbal-bank"
  }
}

resource "null_resource" "deploy_microservices" {
  depends_on = [
    google_compute_instance.service,
    google_compute_instance.database,
    google_container_cluster.application,
    google_sql_database_instance.application,
    null_resource.prepare_manifests,
  ]

  provisioner "local-exec" {
    command     = <<EOT
echo "Get credentials for the cluster" && \
gcloud container clusters get-credentials ${google_container_cluster.application.name} --project ${data.google_project.application.project_id} --region ${var.google_region_application} --quiet  && \
echo "Create the application namespace and service accounts" && \
kubectl create namespace ${local.k8s_app_namespace};
kubectl --namespace ${local.k8s_app_namespace} create serviceaccount ${local.k8s_sa_backend};
echo "Create Cloud SQL Admin secret" && \
kubectl --namespace ${local.k8s_app_namespace} delete secret cloud-sql-admin --ignore-not-found && \
kubectl --namespace ${local.k8s_app_namespace} create secret generic cloud-sql-admin --from-literal=username='${local.database_admin_user_name}' --from-literal=password='${local.database_admin_password}' --from-literal=connectionName='${local.database_connection_name}' && \
echo "Annotate the service accounts for Workload Identity" && \
kubectl annotate serviceaccount ${local.k8s_sa_default} --namespace ${local.k8s_app_namespace} --overwrite iam.gke.io/gcp-service-account=${google_service_account.wi_application_default.email} && \
kubectl annotate serviceaccount ${local.k8s_sa_backend} --namespace ${local.k8s_app_namespace} --overwrite iam.gke.io/gcp-service-account=${google_service_account.wi_application_backend.email} && \
echo "Apply the configuration" && \
kubectl --namespace ${local.k8s_app_namespace} apply -f ${local.application_config_file} && \
echo "Populate the database" && \
kubectl --namespace ${local.k8s_app_namespace} apply -f ${local.populate_job_account_db_yaml} && \
echo "Deploy the application" && \
kubectl --namespace ${local.k8s_app_namespace} apply -f ${local.application_jwt_secret_file} && \
kubectl --namespace ${local.k8s_app_namespace} apply -f ${local.application_userservice_yaml} && \
kubectl --namespace ${local.k8s_app_namespace} apply -f ${local.application_contacts_yaml} && \
kubectl --namespace ${local.k8s_app_namespace} apply -f ${local.application_frontend_yaml} && \
kubectl --namespace ${local.k8s_app_namespace} patch service/frontend --patch "${local.k8s_frontend_service_patch}" && \
kubectl --namespace ${local.k8s_app_namespace} apply -f ${local.application_loadgenerator_yaml} && \
kubectl --namespace ${local.k8s_app_namespace} scale deployment frontend --replicas 2
    EOT
    interpreter = ["bash", "-c"]
    working_dir = "${path.module}/../../cymbal-bank"
  }
}
