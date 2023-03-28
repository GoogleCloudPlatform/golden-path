data "google_compute_network" "default" {
  name = "default"
}

data "google_compute_global_address" "psc_ip_alloc" {
  name = "psc-ip-alloc"
}

resource "google_compute_firewall" "database_psc" {
  name          = "database-psc"
  network       = data.google_compute_network.default.name
  source_ranges = ["${data.google_compute_global_address.psc_ip_alloc.address}/24"]
  target_tags   = data.google_compute_instance.database.tags

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }
}