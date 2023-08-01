### SERVICE ACCOUNT FOR CLOUD RUN ###

resource "google_service_account" "cloudrun-mlflow" {
  account_id   = "cloudrun-mlflow-${var.env}"
  display_name = "Service Account for Cloud Run running ML Flow"
}


### SERVICE ACCOUNT FOR CONNECTING TO MLFLOW ###

resource "google_service_account" "bucket_object_creator" {
  account_id   = "mlflow-connect-${var.env}"
  display_name = "Service Account for create objects in ML Flow bucket."
}

resource "google_service_account_key" "key_to_bucket_object_creator" {
  service_account_id = google_service_account.bucket_object_creator.name
}

resource "google_secret_manager_secret" "bucket_object_creator_account_key" {
  secret_id = "mlflow_service_account_key"
  project   = var.project_name
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "mlflow_key-version-basic" {
  secret      = google_secret_manager_secret.bucket_object_creator_account_key.id
  secret_data = base64decode(google_service_account_key.key_to_bucket_object_creator.private_key)
}
