resource "google_firestore_database" "sage" {
  project     = var.project_id
  name        = local.firestore_database
  location_id = var.region
  type        = "FIRESTORE_NATIVE"

  deletion_policy = "DELETE"

  depends_on = [google_project_service.apis]
}

# Indice vettoriale sul campo "embedding" della collection "chunks"
resource "google_firestore_index" "chunks_embedding" {
  project     = var.project_id
  database    = google_firestore_database.sage.name
  collection  = "chunks"
  query_scope = "COLLECTION"

  fields {
    field_path = "embedding"
    vector_config {
      dimension = var.embedding_dimension
      flat {}
    }
  }
}
