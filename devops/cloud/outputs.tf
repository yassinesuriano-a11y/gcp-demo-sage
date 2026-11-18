output "cloud_run_url" {
  description = "URL del servizio Sage."
  value       = google_cloud_run_v2_service.sage.uri
}

output "artifact_registry_repo" {
  description = "Percorso del repository Docker."
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.sage.repository_id}"
}

output "docs_bucket" {
  value = google_storage_bucket.docs.name
}

output "firestore_database" {
  value = google_firestore_database.sage.name
}

output "bigquery_dataset" {
  value = google_bigquery_dataset.analytics.dataset_id
}

output "runtime_service_account" {
  value = google_service_account.run.email
}
