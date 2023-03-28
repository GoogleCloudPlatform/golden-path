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

resource "google_compute_firewall" "database_service_postgres" {
  name          = "database-service-postgres"
  network       = data.google_compute_network.default.name
  source_tags   = google_compute_instance.service.tags
  target_tags   = google_compute_instance.database.tags

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }
}

resource "google_compute_firewall" "iap_ssh" {
  name          = "iap-ssh"
  network       = data.google_compute_network.default.name
  source_ranges = ["35.235.240.0/20"]
  target_tags   = setunion(google_compute_instance.database.tags, google_compute_instance.service.tags)

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
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

resource "google_compute_global_address" "psc_ip_alloc" {
  name          = "psc-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = data.google_compute_network.default.id
}

resource "google_service_networking_connection" "default" {
  depends_on = [google_project_service.servicenetworking_googleapis_com]    

  network                 = data.google_compute_network.default.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.psc_ip_alloc.name]
}