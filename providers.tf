terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.60"
    }
  }
}

provider "google" {
  project     = "projetocloud-417315"
  region      = "europe-southwest1"
  credentials = "./keys.json"
}
