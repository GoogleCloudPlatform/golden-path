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
