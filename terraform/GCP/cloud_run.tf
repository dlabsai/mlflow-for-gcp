data "google_project" "project" {
  project_id = var.project_name
}

resource "google_cloud_run_v2_service" "mlflow_on_cloudrun" {
  name     = "mlflow-${var.project_name}-${var.env}"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"
  client   = "cloud-console"

  depends_on = [google_service_account.cloudrun-mlflow, google_artifact_registry_repository.ar_mlflow]

  template {
    service_account = google_service_account.cloudrun-mlflow.email
    volumes {
      name = "cloudsql"

      cloud_sql_instance {
        instances = [
          google_sql_database_instance.main.connection_name,
        ]
      }
    }
    scaling {
      max_instance_count = 10
    }
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_name}/${google_artifact_registry_repository.ar_mlflow.name}/${var.image_name}:latest"
      env {
        name  = "GCP_PROJECT"
        value = data.google_project.project.number
      }
      volume_mounts {
        mount_path = "/cloudsql"
        name       = "cloudsql"
      }

      resources {
        cpu_idle = true
        limits = {
          cpu    = "1000m" # 1 vCPU
          memory = "1024Mi"
        }
      }
    }
  }
}

resource "google_cloud_run_service_iam_binding" "access_to_mlflow" {
  location = google_cloud_run_v2_service.mlflow_on_cloudrun.location
  service  = google_cloud_run_v2_service.mlflow_on_cloudrun.name
  role     = "roles/run.invoker"
  members = [
    "allUsers"
  ]
}

resource "google_artifact_registry_repository" "ar_mlflow" {
  location      = var.region
  repository_id = "${var.project_name}-repo"
  description   = "Docker repository for MlFlow"
  format        = "DOCKER"
}