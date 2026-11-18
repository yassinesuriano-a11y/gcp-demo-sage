terraform {
  required_version = ">= 1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }

  # Configurazione parziale: bucket e prefix arrivano da backend.hcl
  # (terraform init -backend-config=backend.hcl)
  backend "gcs" {}
}
