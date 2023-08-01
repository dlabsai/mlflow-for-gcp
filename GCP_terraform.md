## Documentation for terraform files [HERE](terraform/GCP/README.md)

## Main documentation [HERE](GCP_base.md) (read it first)

## Activate needed APIs
In order to be able to start this project you need to activate following APIs, take into account that activating some of them can take even up to 24h.

- https://console.developers.google.com/apis/api/secretmanager.googleapis.com
- https://console.developers.google.com/apis/api/artifactregistry.googleapis.com
- https://console.developers.google.com/apis/api/run.googleapis.com 
- https://console.developers.google.com/apis/api/sqladmin.googleapis.com 



## Terraform setup
1. Install terraform - [link to the official documentation](https://link-url-here.org)
2. Install terraform-docs for automatic documentation (optional) [terraform-docs](https://terraform-docs.io/user-guide/introduction/)

## Bucket for status
Bucket need to be created to hold terraform status, keeping status locally is possible but it is a bad idea. Input bucket name in `main.tf`.

## Input your variables
The variables specific to the project need to be put into [variables.tf](terraform/GCP/variables.tf). If you dont use VPN you can input 0.0.0.0/0 in *vpn_to_access_db* (it means that the service will be accessible from any IP).


### Use `terraform init` to install providers and initialise terraform backend.

## Artifact Registry

First we need to create repository, use command :

`terraform apply -target="google_artifact_registry_repository.ar_mlflow"`

You need to build, tag and push docker image to the *Artifact Registry* in order to be able to use it to spin a *Cloud Run* deployment.

Get a recent version of docker. Follow the installation instruction from official docker [documentation.](https://docs.docker.com/engine/install/ubuntu/)

The docker images are going to be pushed to Artifact Registry inside your GCP project.

*You need to change project id and region in the commands for the ones you are using. If you have any problems with artifact registry refer to the [official documentation](https://cloud.google.com/artifact-registry/docs/docker/pushing-and-pulling)*

Setup *docker* auth once:

```sh
gcloud auth configure-docker europe-west2-docker.pkg.dev
```

build imagine :

```sh
docker build -t mlflow-gcp .
```

tag :
```sh
docker tag mlflow-gcp europe-west2-docker.pkg.dev/test-ml-flow-terraform/test-ml-flow-terraform-repo/mlflow-imagine:latest
```

and push :
```sh
docker push europe-west2-docker.pkg.dev/test-ml-flow-terraform/test-ml-flow-terraform-repo/mlflow-imagine:latest
```

## Start terraform deployment
- use `terraform plan` to se what resources will be created
- use `terraform apply` to create resources

   
