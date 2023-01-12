resource "google_project_service" "container_googleapis_com" {
  disable_dependent_services = true
  service                    = "container.googleapis.com"
}

resource "google_container_cluster" "processing" {
  depends_on = [google_project_service.container_googleapis_com]

  initial_node_count = 1
  location           = var.google_zone_application
  name               = "processing-cluster"

  node_config {
    machine_type = "e2-standard-8"
    tags         = ["processing-cluster"]
  }
  release_channel {
    channel = "REGULAR"
  }
  workload_identity_config {
    workload_pool = "${data.google_project.application.project_id}.svc.id.goog"
  }
}
