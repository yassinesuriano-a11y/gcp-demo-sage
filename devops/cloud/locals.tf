# Unico punto in cui si decide come si chiamano le risorse.
locals {
  shared = var.resource_prefix != ""

  # Cloud Run e Artifact Registry
  service_name = local.shared ? "${var.resource_prefix}-sage" : "sage"

  # Bucket documenti
  docs_bucket = local.shared ? "${var.resource_prefix}-sage-docs" : "${var.project_id}-sage-docs"

  # Firestore: in un progetto c'è un solo "(default)", quindi un database per persona
  firestore_database = local.shared ? var.resource_prefix : "(default)"

  # BigQuery: i dataset non ammettono trattini
  bq_dataset = local.shared ? "${replace(var.resource_prefix, "-", "_")}_sage_analytics" : "sage_analytics"

  # Service account: max 30 caratteri, se serve si accorcia con un hash
  sa_account_id_full = local.shared ? "${var.resource_prefix}-sage-run" : "sage-run"
  sa_account_id = (
    length(local.sa_account_id_full) <= 30
    ? local.sa_account_id_full
    : "${substr(var.resource_prefix, 0, 13)}-${substr(sha1(var.resource_prefix), 0, 6)}-sage-run"
  )

  labels = {
    app     = "sage"
    managed = "terraform"
  }
}
