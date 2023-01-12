locals {
  frontend_endpoint     = "app.endpoints.${data.google_project.application.project_id}.cloud.goog"
  frontend_openapi_yaml = templatefile("${path.module}/templates/endpoint-openapi.tftpl", { endpoint = local.frontend_endpoint, ip_address = google_compute_address.application.address })
  pod_ipv4_cidr_block   = google_container_cluster.application.node_pool[0].network_config[0].pod_ipv4_cidr_block
}

data "google_compute_network" "default" {
  depends_on = [google_project_service.compute_googleapis_com]

  name = "default"
}

resource "google_compute_address" "application" {
  depends_on = [google_project_service.compute_googleapis_com]

  address_type = "EXTERNAL"
  name         = "application-address"
  region       = var.google_region_application
}

resource "google_endpoints_service" "openapi_service" {
  service_name   = local.frontend_endpoint
  project        = data.google_project.application.project_id
  openapi_config = local.frontend_openapi_yaml
}

resource "google_compute_firewall" "service_gke_application_cluster" {
  name          = "service-gke-application-cluster"
  network       = data.google_compute_network.default.name
  source_ranges = [local.pod_ipv4_cidr_block]
  target_tags   = google_compute_instance.service.tags

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
}

resource "google_compute_firewall" "database_gke_application_cluster" {
  name          = "database-gke-application-cluster"
  network       = data.google_compute_network.default.name
  source_ranges = [local.pod_ipv4_cidr_block]
  target_tags   = google_compute_instance.database.tags

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }
}
