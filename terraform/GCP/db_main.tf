resource "google_sql_database_instance" "main" {
  name             = "${var.project_name}-${var.env}-db"
  database_version = "POSTGRES_14"
  project          = var.project_name

  settings {
    tier            = "db-custom-1-3840" # vCPUs: 1 Memory: 3.75 GB
    disk_size       = "10"               # HDD storage: 10 GB
    disk_type       = "PD_HDD"
    disk_autoresize = false
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "Your VPN"
        value = var.vpn_to_access_db
      }
    }

  }
}
