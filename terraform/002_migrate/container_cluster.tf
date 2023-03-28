resource "google_project_service" "container_googleapis_com" {
  disable_dependent_services = true
  service                    = "container.googleapis.com"
}

resource "google_container_cluster" "processing" {
  depends_on = [google_project_service.container_googleapis_com]

  enable_shielded_nodes = true
  initial_node_count    = 1
  location              = var.google_zone_application
  name                  = "processing-cluster"
  networking_mode       = "VPC_NATIVE"

  ip_allocation_policy{
  }
  node_config {
    machine_type = "e2-standard-8"
    tags         = ["processing-cluster"]

    shielded_instance_config {
      enable_secure_boot = true
    }
  }
  private_cluster_config {
    enable_private_nodes   = true
    master_ipv4_cidr_block = "172.16.0.32/28"
  }
  release_channel {
    channel = "REGULAR"
  }
  workload_identity_config {
    workload_pool = "${data.google_project.application.project_id}.svc.id.goog"
  }
}
