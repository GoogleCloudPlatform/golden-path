resource "google_service_account" "m2c_gce_source" {
  account_id   = "m2c-gce-source"
  display_name = "Migrate to Containers GCE Source Service Account"
}

resource "google_service_account" "m2c_install" {
  account_id   = "m2c-install"
  display_name = "Migrate to Containers Install Service Account"
}
