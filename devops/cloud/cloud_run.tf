resource "google_cloud_run_v2_service" "sage" {
  project             = var.project_id
  name                = local.service_name
  location            = var.region
  ingress             = "INGRESS_TRAFFIC_ALL"
  deletion_protection = false
  labels              = local.labels

  template {
    service_account = google_service_account.run.email

    scaling {
      min_instance_count = 0
      max_instance_count = 3
    }

    containers {
      # Placeholder: l'immagine reale la pubblica deploy.yml (gcloud run deploy --image ...)
      image = var.placeholder_image

      # I nomi delle variabili devono combaciare con quelli letti dal codice in sources/backend
      env {
        name  = "GCP_PROJECT"
        value = var.project_id
      }
      env {
        name  = "GCP_REGION"
        value = var.region
      }
      env {
        name  = "FIRESTORE_DATABASE"
        value = google_firestore_database.sage.name
      }
      env {
        name  = "BQ_DATASET"
        value = google_bigquery_dataset.analytics.dataset_id
      }
      env {
        name  = "DOCS_BUCKET"
        value = google_storage_bucket.docs.name
      }
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].containers[0].image,
      client,
      client_version,
    ]
  }

  depends_on = [
    google_project_service.apis,
    google_project_iam_member.run_vertex,
    google_project_iam_member.run_firestore,
  ]
}

# Espone /api/ask pubblicamente
resource "google_cloud_run_v2_service_iam_member" "public" {
  project  = var.project_id
  location = google_cloud_run_v2_service.sage.location
  name     = google_cloud_run_v2_service.sage.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
