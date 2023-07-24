### BUCKET FOR MLFLOW ARTIFACTS ###

resource "google_storage_bucket" "mlflow_artifacts_bucket" {
  name                        = "${var.project_name}-mlflow-${var.env}-${var.region}"
  project                     = var.project_name
  location                    = "EUROPE-WEST2"
  storage_class               = "REGIONAL"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false
}


### BUCKET URL IN SECRET ###

resource "google_secret_manager_secret" "mlflow_artifact_url" {
  secret_id = "mlflow_artifact_url"
  project   = var.project_name
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "ml-flow-artifact-url-version-basic" {
  secret      = google_secret_manager_secret.mlflow_artifact_url.id
  secret_data = google_storage_bucket.mlflow_artifacts_bucket.url
}