locals {
  database_env_config = <<EOT
VERSION="v0.3.1"
PORT="8080"
JVM_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap"
LOCAL_ROUTING_NUM="883745000"
PUB_KEY_PATH="/opt/monolith/publickey"
POSTGRES_VERSION="14"
POSTGRES_DB="postgresdb"
POSTGRES_USER="postgres"
POSTGRES_PASSWORD="password"
USE_DEMO_DATA="True"
ENABLE_TRACING="true"
ENABLE_METRICS="true"
SPRING_DATASOURCE_USERNAME="postgres"
SPRING_DATASOURCE_PASSWORD="password"
EOT

  application_env_config = <<EOT
${local.database_env_config}SPRING_DATASOURCE_URL="jdbc:postgresql://${google_compute_instance.database.name}:5432/postgresdb"
EOT
}

data "google_compute_image" "default" {
  depends_on = [google_project_service.compute_googleapis_com]

  family  = "ubuntu-1804-lts"
  project = "ubuntu-os-cloud"
}

data "local_file" "startup_script" {
  filename = "${path.module}/../../cymbal-bank/src/ledgermonolith/init/install-script.sh"
}

resource "google_compute_instance" "service" {
  depends_on = [google_project_service.compute_googleapis_com]

  description             = "env-config SHA512 hash (base64): ${base64sha512(local.application_env_config)}"
  machine_type            = "e2-standard-4"
  metadata_startup_script = data.local_file.startup_script.content
  name                    = "ledger-service"
  tags                    = ["ledger-service"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.default.self_link
    }
  }
  metadata = {
    "env-config"        = local.application_env_config
    "install-component" = "service"
  }
  network_interface {
    network = "default"

    access_config {
    }
  }
  service_account {
    email  = google_service_account.vm_service.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "database" {
  depends_on = [google_project_service.compute_googleapis_com]

  description             = "env-config SHA512 hash (base64): ${base64sha512(local.database_env_config)}"
  machine_type            = "n2-standard-4"
  metadata_startup_script = data.local_file.startup_script.content
  name                    = "ledger-database"
  tags                    = ["ledger-database"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.default.self_link
    }
  }
  metadata = {
    "env-config"        = local.database_env_config
    "install-component" = "database"
  }
  network_interface {
    network = "default"

    access_config {
    }
  }
  scratch_disk {
    interface = "SCSI"
  }
  service_account {
    email  = google_service_account.vm_database.email
    scopes = ["cloud-platform"]
  }
}
