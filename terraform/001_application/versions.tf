terraform {
  backend "local" {
    path = "state/default.tfstate"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.47.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.47.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
  }

  required_version = ">= 1.3.5, < 2.0.0"
}

provider "google" {
  project = var.google_project_id_application
  region  = var.google_region_application
  zone    = var.google_zone_application
}

provider "google-beta" {
  project = var.google_project_id_application
  region  = var.google_region_application
  zone    = var.google_zone_application
}

provider "local" {
}
