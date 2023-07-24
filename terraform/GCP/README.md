# ML Flow implementation for GCP
## Files overview
`bucket_storage.tf` - Creates bucket that will store Ml Flow artifacts. Secret is created to hold url to bucket.

`cloud_run.tf` - Holds configuration for the CloudRun implementation. The resources assigned are sufficient for the low traffic, cpu will be assigned only when the application is in use.

`db_main.tf` - DB instance using postgres (just instance itself database is created in separate file).

`db_mlflow.tf` - Data-base and its user, the user data (username and password) and url for database are placed in secrets as it will be used later.

`iam.tf` - IAM policy for database, secrets and bucket.

`main.tf` - Basic data about the project setup.

`service_accounts.tf` - Service account for the CloudRun and for objects creation in bucket.

`variables.tf` - Variables that need to be adjusted for individual project.



<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 4.58.0 |
## Resources

| Name | Type |
|------|------|
| [google_artifact_registry_repository.ar_mlflow](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/artifact_registry_repository) | resource |
| [google_cloud_run_service_iam_binding.access_to_mlflow](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/cloud_run_service_iam_binding) | resource |
| [google_cloud_run_v2_service.mlflow_on_cloudrun](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/cloud_run_v2_service) | resource |
| [google_project_iam_member.cloudsql_connect](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/project_iam_member) | resource |
| [google_secret_manager_secret.bucket_object_creator_account_key](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret.db_login_ml_flow](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret.db_password_ml_flow](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret.mlflow_artifact_url](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret.mlflow_database_url](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_iam_member.db_login_ml_flow_accessor](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_iam_member.db_password_ml_flow_accessor](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_iam_member.mlflow_artifact_url_accessor](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_iam_member.mlflow_database_url_accessor](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_version.ml-flow-artifact-url-version-basic](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/secret_manager_secret_version) | resource |
| [google_secret_manager_secret_version.ml-flow-pass-version-basic](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/secret_manager_secret_version) | resource |
| [google_secret_manager_secret_version.ml-flow-username-version-basic](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/secret_manager_secret_version) | resource |
| [google_secret_manager_secret_version.mlflow_database_url-version-basic](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/secret_manager_secret_version) | resource |
| [google_secret_manager_secret_version.mlflow_key-version-basic](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/secret_manager_secret_version) | resource |
| [google_service_account.bucket_object_creator](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/service_account) | resource |
| [google_service_account.cloudrun-mlflow](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/service_account) | resource |
| [google_service_account_key.key_to_bucket_object_creator](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/service_account_key) | resource |
| [google_sql_database.ml_flow_db](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/sql_database) | resource |
| [google_sql_database_instance.main](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/sql_database_instance) | resource |
| [google_sql_user.ml_flow_user](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/sql_user) | resource |
| [google_storage_bucket.mlflow_artifacts_bucket](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_policy.policy_bucket_object_create](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/resources/storage_bucket_iam_policy) | resource |
| [random_password.db_password_ml_flow](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [google_iam_policy.mlflow-bucket-policy](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/data-sources/iam_policy) | data source |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/4.58.0/docs/data-sources/project) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_users_list"></a> [bucket\_users\_list](#input\_bucket\_users\_list) | List of users | `list` | `[]` | no |
| <a name="input_env"></a> [env](#input\_env) | Name of the environment | `string` | `"prod"` | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | Name of the imagine that will be used. | `string` | `"mlflow-imagine"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Full name of the project | `string` | `"test-ml-flow-terraform"` | no |
| <a name="input_region"></a> [region](#input\_region) | GCP region that will be used for the project | `string` | `"europe-west2"` | no |
| <a name="input_vpn_to_access_db"></a> [vpn\_to\_access\_db](#input\_vpn\_to\_access\_db) | VPN that will be used to connect to DB, while using 0.0.0.0/0 the application will be available from any IP (it will be accessible from the internet). | `string` | `"0.0.0.0/0"` | no |
The inputs need to be updated with correct values before the project can be started.
Either in variables.tf or in terraform.tfvars.
## Outputs

No outputs.
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->