# Service account con cui gira Cloud Run, a privilegio minimo
resource "google_service_account" "run" {
  project      = var.project_id
  account_id   = local.sa_account_id
  display_name = "Sage Cloud Run runtime (${local.service_name})"

  depends_on = [google_project_service.apis]
}

# Vertex AI (embeddings e generazione)
resource "google_project_iam_member" "run_vertex" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.run.email}"
}

# Firestore
resource "google_project_iam_member" "run_firestore" {
  project = var.project_id
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.run.email}"
}

# BigQuery: eseguire job + scrivere solo nel proprio dataset
resource "google_project_iam_member" "run_bq_jobs" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.run.email}"
}

resource "google_bigquery_dataset_iam_member" "run_bq_data" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.analytics.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.run.email}"
}

# Bucket documenti: sola lettura
resource "google_storage_bucket_iam_member" "run_docs" {
  bucket = google_storage_bucket.docs.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.run.email}"
}

# Bucket istruzioni: sola lettura
resource "google_storage_bucket_iam_member" "run_instructions" {
  bucket = google_storage_bucket.instructions.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.run.email}"
}