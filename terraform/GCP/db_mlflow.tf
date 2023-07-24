### DATABASE ###

resource "google_sql_database" "ml_flow_db" {
  name     = "mlflow-${var.project_name}-${var.env}"
  instance = google_sql_database_instance.main.name
  project  = var.project_name
}


### DATABASE USER ###

resource "google_sql_user" "ml_flow_user" {
  name     = "mlflow-${var.project_name}-${var.env}"
  instance = google_sql_database_instance.main.name
  password = random_password.db_password_ml_flow.result
  project  = var.project_name
}


### LOGIN ###

resource "google_secret_manager_secret" "db_login_ml_flow" {
  secret_id = "mlflow_tracking_username"
  project   = var.project_name
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "ml-flow-username-version-basic" {
  secret      = google_secret_manager_secret.db_login_ml_flow.id
  secret_data = google_sql_user.ml_flow_user.name
}


### PASSWORD ###

resource "random_password" "db_password_ml_flow" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "google_secret_manager_secret" "db_password_ml_flow" {
  secret_id = "mlflow_tracking_password"
  project   = var.project_name
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "ml-flow-pass-version-basic" {
  secret      = google_secret_manager_secret.db_password_ml_flow.id
  secret_data = random_password.db_password_ml_flow.result
}


### DATABASE URL ###

resource "google_secret_manager_secret" "mlflow_database_url" {
  secret_id = "mlflow_database_url"
  project   = var.project_name
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "mlflow_database_url-version-basic" {
  secret      = google_secret_manager_secret.mlflow_database_url.id
  secret_data = "postgresql+psycopg2://${google_sql_user.ml_flow_user.name}:${random_password.db_password_ml_flow.result}@/${google_sql_database.ml_flow_db.name}?host=/cloudsql/${google_sql_database_instance.main.connection_name}"
}