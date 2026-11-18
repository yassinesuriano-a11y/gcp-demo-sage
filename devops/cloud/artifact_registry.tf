resource "google_artifact_registry_repository" "sage" {
  project       = var.project_id
  location      = var.region
  repository_id = local.service_name
  format        = "DOCKER"
  description   = "Immagini Docker dell'API Sage"
  labels        = local.labels

  depends_on = [google_project_service.apis]
}
