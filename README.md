# Secured `mlflow` for GCP

This repository contains the docker image for running `mlflow` on GCP's *Cloud Run*
as well as sample client code.

## Deployment

The deployment uses managed *Cloud SQL* database, *Cloud Storage* bucket for artifact storage,
*Secret Manager* for obtaining secrets at run time, *Container Registry* for docker
image storage and *Cloud Run* for managed, serverless runtime environment.

### GCP CLI

You need to install *GCP* CLI tools (`gcloud`) and configure it in order to push docker images to *GCR*.

### Service account

Create a service account and set its privileges (`owner` is easiest).

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
* `mlflow_database_url` - SQLAlchemy-format *Cloud SQL* connection string (over internal *GCP* interfaces, not through IP), sample value `postgresql+pg8000://<dbuser>:<dbpass>@/<dbname>?unix_sock=/cloudsql/dlabs:europe-west3:mlfow/.s.PGSQL.5432`, the *Cloud SQL* instance name can be copied from *Cloud SQL* instance overview page
* `mlflow_tracking_username` - the basic HTTP auth username for `mlflow`, your choice, sample value `dlabs-developer`
* `mlflow_tracking_password` - the basic HTTP auth password for `mlflow`, your choice

### Container Registry

You need to build, tag and push this docker image to the *Container Registry* in order to be able to use it to spin a *Cloud Run* deployment. How you build the image depends on your platform.

#### Linux 64-bit Machines

First thing you will need is a recent version of docker. Please mind the fact that system-provided versions of docker won't cut it. Please follow the installation instruction from official docker documentation: https://docs.docker.com/engine/install/ubuntu/.

The docker images are going to be pushed to Container Registry inside your GCP project. You need to specify the name of your project:
```sh
export GCP_PROJECT=name_of_your_project
```
The name of the project can be copied from the URL segment of your GCP console. For example from `https://console.cloud.google.com/home/dashboard?organizationId=XXX&project=YYY` you need to copy `YYY`. Please note that the project name can differ from project label that you set when creating the project from the GCP UI.

Setup *docker* auth once:

```sh
make docker-auth
```

then build, tag and push:

```sh
make build && make tag && make push
```

#### Non Linux 64-bit Machines

According to the Google Cloud Run [documentation](https://cloud.google.com/run/docs/troubleshooting#container-failed-to-start), the container image must be compiled for 64-bit Linux. If you aren't on a 64-bit Linux machine, you may instead build the image using Google Cloud Build. 

1. Navigate to the [Cloud Build](https://console.cloud.google.com/cloud-build) page and activate it.
1. Build and push with the following commands, replacing the variables as desired:
    ````
    IMAGE_NAME=mlflow-gcp
    VERSION=0.20
    GCP_PROJECT=urbn-data-science
    IMAGE_URL="gcr.io/${GCP_PROJECT}/${IMAGE_NAME}:${VERSION}"
    gcloud builds submit --tag $IMAGE_URL
    ````

### Cloud Run

Create a new *Cloud Run* deployment using the image you just pushed to the *Container Registry*.

Select "Allow unauthenticated invocations" to enable incoming web traffic (ML flow will be protected by HTTP basic auth at a later step).

Give the machine 1GB of RAM. Use the service account you created earlier. You can decrease the maximum number of instances.

Use the previously created service account in order for your Cloud Run to be able to retrieve credentials.

In the *Connections* tab add a connection to your *Cloud SQL* instance.

In the *Variables* tab add the following variable:

* `GCP_PROJECT` - the name of your GCP project. This is needed for the containerized app to know from which project to retrieve the secrets from. Sample value `dlabs`.

## Usage

In order to use the deployed `mlflow` you need:

* browser access to the deployed `mlflow` (that is URL, username and password)
* write access to the storage bucket (in order to save model artifacts)

### `mlflow` access

Visit the `mlflow` URL and when prompted for password, input the `mlflow` credentials.
If you are able to log in and see the web UI, you are ready to configure `mlflow`
locally for your project.

#### Install client library

You need to install `mlflow` library (use your project-preferred method).

#### Environment configuration

Configure the following environment variables:

* `MLFLOW_TRACKING_URI=https://<your cloud run deployment URL.a.run.app>`
* `MLFLOW_TRACKING_USERNAME=<mlflow access username>`
* `MLFLOW_TRACKING_PASSWORD=<mlflow access password>`
* `MLFLOW_EXPERIMENT_NAME=my_little_pony` - the name of your experiment (needs to be created beforehand - through web UI or `mlflow` CLI).

### Storage bucket access

You need to have programmatic access to storage bucket in order to save model artifacts.

#### Install client libary

You need to install cloud storage client library `google-cloud-storage` (use your project-preferred method).

#### Environment configuration

Obtain the JSON file with credentials for the GCP service account connected to the storage bucket.

Configure the following environment variable:

* `GOOGLE_APPLICATION_CREDENTIALS=/home/<user>/<absolute path>/credentials.json` - the path to the service account credentials JSON file.

### Usage

From your notebook or you script use the following template for tracking your training in `mlflow`:

```python
import mlflow
from pathlib import Path

with mlflow.start_run(run_name="<name of your run, doesn't have to be unique>"):
    # Log training parameters
    mlflow.log_param("lr", 1e-5)
    for epoch in range(10):
        # Log metrics multiple times during training
        mlflow.log_metric(
            "accuracy", 90 + epoch, step=epoch
        )
    # Save model
    models_dir = Path(...)
    model_file_path = models_dir / "model.pickle"
    ... # here we store the model
    # Upload any files to storage bucket
    mlflow.log_artifact(model_file_path)
```

## Tips

It's recommended to use software like `direnv` to keep track of your environment variables.

## The sample client

You can see `sample_client` directory for an example client code for deployed `mlflow` usage.

* Set your environment variables (see `.envrc.template`)
* Install your dependencies (`requirements.txt`)
* Run the sample `python3 check_tracking.py`
