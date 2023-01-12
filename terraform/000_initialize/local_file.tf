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
