resource "google_bigquery_dataset" "analytics" {
  project       = var.project_id
  dataset_id    = local.bq_dataset
  location      = var.region
  friendly_name = "Sage analytics"
  labels        = local.labels

  delete_contents_on_destroy = true

  depends_on = [google_project_service.apis]
}

# ATTENZIONE: lo schema deve combaciare con le colonne scritte da
# sources/backend/src/sage/integrations/bigquery/question_log.py
resource "google_bigquery_table" "question_log" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.analytics.dataset_id
  table_id            = "question_log"
  deletion_protection = false

  time_partitioning {
    type  = "DAY"
    field = "timestamp"
  }

  schema = jsonencode([
    { name = "timestamp", type = "TIMESTAMP", mode = "REQUIRED" },
    { name = "question", type = "STRING", mode = "NULLABLE" },
    { name = "answer", type = "STRING", mode = "NULLABLE" },
    { name = "latency_ms", type = "INTEGER", mode = "NULLABLE" },
  ])
}
