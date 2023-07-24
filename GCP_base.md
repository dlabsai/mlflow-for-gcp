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

## Infrastructure set up

- [Terraform approach (recommended)](GCP_terraform.md)
- [Hands-on approach](GCP_hands_on.md)

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
