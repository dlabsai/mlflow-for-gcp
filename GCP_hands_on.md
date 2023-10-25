### Cloud SQL

Create a *PostgreSQL* managed *Cloud SQL* instance.
Setup public IP access.
Setup SSL and enforce it.

Enable *Cloud SQL Admin API* and create a new database with a new user (you don't want `mlflow` to have ownership of your whole database).
Alternatively you can execute the following SQL statements in the database:
```sql
create database mlflow;
create user mlflow with encrypted password 'some-password';
grant all privileges on database mlflow to mlflow;
```

### Storage bucket

Create a new *Cloud Storage* bucket for storing model artifacts.

### Secret Mananger

In *Secret Manager* you need to configure secrets that the `mlflow` image will retrieve at boot time:

* `mlflow_artifact_url` - path to your *Cloud Storage* bucket, sample value `gs://mlflow`
* `mlflow_database_url` - SQLAlchemy-format *Cloud SQL* connection string (over internal *GCP* interfaces, not through IP), sample value `postgresql+pg8000://<dbuser>:<dbpass>@/<dbname>?unix_sock=/cloudsql/dlabs:europe-west3:mlfow/.s.PGSQL.5432`, the *Cloud SQL* instance name can be copied from *Cloud SQL* instance overview page. For `dbuser` and `dbapss` values use user name and password created in `Cloud SQL` section
* `mlflow_tracking_username` - the basic HTTP auth username for `mlflow`, your choice, sample value `dlabs-developer`
* `mlflow_tracking_password` - the basic HTTP auth password for `mlflow`, your choice

Add `Secret Manager Secret Accessor` permission to all created secrets for Compute Service Account
### Container Registry

You need to build, tag and push docker image to the *Artifact Registry* in order to be able to use it to spin a *Cloud Run* deployment.

First thing you will need is a recent version of docker. Please mind the fact that system-provided versions of docker won't cut it. Please follow the installation instruction from official docker documentation: https://docs.docker.com/engine/install/ubuntu/.

The docker images are going to be pushed to Artifact Registry inside your GCP project. You need to specify the name of your project:
```sh
export GCP_PROJECT=name_of_your_project
```
The name of the project can be copied from the URL segment of your GCP console. For example from `https://console.cloud.google.com/home/dashboard?organizationId=XXX&project=YYY` you need to copy `YYY`. Please note that the project name can differ from project label that you set when creating the project from the GCP UI.

Also before using Makefile, you need to specify values for those variables
```sh
IMAGE_NAME=mlflow-gcp # Image name in Artifact Registry
AR_REGISTRY_NAME=mlflow-gcp # Artifact Registry name
AR_REGION=europe-west2 # Region used for Artifact Registry
```

Setup *docker* auth once:

```sh
make docker-auth
```

then build, tag and push:

```sh
make build && make tag && make push
```
## Apple Silicon
If you are building image on computer with Apple Silicon (ARM) you need to use `make build-m1` instead of `make build` command  


### Cloud Run

Create a new *Cloud Run* deployment using the image you just pushed to the *Artifact Registry*.

Select "Allow unauthenticated invocations" to enable incoming web traffic (ML flow will be protected by HTTP basic auth at a later step).

Give the machine 1GB of RAM. Use the service account you created earlier. You can decrease the maximum number of instances.

Use the previously created service account in order for your Cloud Run to be able to retrieve credentials.

In the *Connections* tab add a connection to your *Cloud SQL* instance.

In the *Variables* tab add the following variable:

* `GCP_PROJECT` - the name of your GCP project. This is needed for the containerized app to know from which project to retrieve the secrets from. Sample value `dlabs`.
