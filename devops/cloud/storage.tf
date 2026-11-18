resource "google_storage_bucket" "docs" {
  name                        = local.docs_bucket
  project                     = var.project_id
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = true # ambiente di corso: si può distruggere anche se non vuoto
  labels                      = local.labels

  depends_on = [google_project_service.apis]
}
