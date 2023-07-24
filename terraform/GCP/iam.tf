### ACCESS TO DB ###

resource "google_project_iam_member" "cloudsql_connect" {
  project = var.project_name
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloudrun-mlflow.email}"
}


### ACCESS TO SECRETS ###

resource "google_secret_manager_secret_iam_member" "db_login_ml_flow_accessor" {
  secret_id = google_secret_manager_secret.db_login_ml_flow.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloudrun-mlflow.email}"
}

resource "google_secret_manager_secret_iam_member" "db_password_ml_flow_accessor" {
  secret_id = google_secret_manager_secret.db_password_ml_flow.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloudrun-mlflow.email}"
}

resource "google_secret_manager_secret_iam_member" "mlflow_artifact_url_accessor" {
  secret_id = google_secret_manager_secret.mlflow_artifact_url.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloudrun-mlflow.email}"
}

resource "google_secret_manager_secret_iam_member" "mlflow_database_url_accessor" {
  secret_id = google_secret_manager_secret.mlflow_database_url.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloudrun-mlflow.email}"
}


### ACCESS TO BUCKET ###

data "google_iam_policy" "mlflow-bucket-policy" {
  binding {
    role    = "roles/storage.objectViewer"
    members = concat(var.bucket_users_list, ["serviceAccount:${google_service_account.cloudrun-mlflow.email}"])
  }
  binding {
    role = "roles/storage.objectCreator"
    members = [
      "serviceAccount:${google_service_account.bucket_object_creator.email}",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "policy_bucket_object_create" {
  bucket      = google_storage_bucket.mlflow_artifacts_bucket.name
  policy_data = data.google_iam_policy.mlflow-bucket-policy.policy_data

  depends_on = [google_service_account.cloudrun-mlflow, google_storage_bucket.mlflow_artifacts_bucket]
}
